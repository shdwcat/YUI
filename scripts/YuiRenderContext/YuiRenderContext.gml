/// @description The render context tracks information for the current render pass of a document.
/// @param resources
/// @param document
/// @param cursor_pos
function YuiRenderContext(_resources, _document) constructor {
	// shared across all ro_contexts
	document = _document;
	resources = _resources;
	overlays = [];
	hotspots = [];
	
	// sometimes unique to ro_context
	slot_inputs = undefined;	
	overlay_id = undefined;
	
	
	static screen_size = {
		w: window_get_width(),
		h: window_get_height(),
	};
	
	/// @func copy()
	/// @desc copy the current render context
	static copy = function() {
		var copy = new YuiRenderContext(resources, document);
		copy.slot_inputs = slot_inputs;
		copy.overlays = overlays;
		copy.hotspots = hotspots;
		copy.overlay_id = overlay_id;
		return copy;
	}
	
	/// @func resolveBinding(binding_value, data)
	static resolveBinding = function(binding, data) {
		
		// I *believe* the actual slot mappings are static, so as soon as we've found a
		// $slot binding, we should be able to replace that with the input, so:
		//     size: { $slot: icon_size }
		// then becomes:
		//     size: 64
		// if the slot input from the template element is 64.
		// This is okay because we copy the template definition for each template instance.
		// I *believe* this should still work for nested templates as well.
		
		// if we can pass the slots inputs down when creating the element tree,
		// then yui_bind() can check for $slot and immediately replace it with the slot_input
		// then we don't have to do any $slot binding at runtime
		// slot_inputs need to be preserved on the element so that they can be passed in to
		// new elements created at runtime (data templates etc)
	
		
		// if the binding is to a slot, get that value from the slot_inputs
		if is_struct(binding) && variable_struct_exists(binding, "$slot") {
			if slot_inputs != undefined {
				var slot_binding = binding;
				var slot_input_key = slot_binding[$ "$slot"];
				var slot_result = slot_inputs[$ slot_input_key];
				
				if slot_result == undefined && !variable_struct_exists(slot_inputs, slot_input_key) {					
					throw "ERROR: Trying to bind to nonexistent slot input: " + slot_input_key;
				}
								
				// if the slot result is a binding, resolve that!
				var slot_result_is_binding = is_struct(slot_result) && variable_struct_exists(slot_result, "path");
				if slot_result_is_binding {
					// if the slot result is not a YuiBinding, bind it and update it in place
					if instanceof(slot_result) != "YuiBinding" {
						slot_result = yui_bind(slot_result, resources);
						slot_inputs[$ slot_input_key] = slot_result;
					}
					
					slot_result = resolveBinding(slot_result, data);
				}
				
				// if the slot input has its own fields (aka transform),
				// resolve that using binding logic as well
				var slot_binding_has_more_fields = array_length(variable_struct_get_names(slot_binding)) > 1;
				if (slot_binding_has_more_fields) {
					
					// set the path to $data if its not specified
					if !variable_struct_exists(slot_binding, "path") slot_binding.path = "$data";
					
					// resolve the slot binding
					return yui_resolve_binding(slot_binding, slot_result, resources);
				}
				else {
					// otherwise return the result
					return slot_result;
				}					
			}
			else {
				throw "ERROR: Trying to bind to slot input '" + slot_input_key + "' when no slot_inputs exist.";
			}
		}
		
		return yui_resolve_binding(binding, data, resources);
	}
		
	/// @func addOverlay(overlay)
	static addOverlay = function(overlay) {
		array_push(overlays, overlay);
	}
	
	/// @func getAnimationState(id)
	static getAnimationState = function(id) {
		return document.previous_animation_states[$ id];
	}
	
	/// @func setAnimationState(id, state)
	static setAnimationState = function(id, state) {
		document.next_animation_states[$ id] = state;
	}
	
	/// @func applyStateChange(id, stateChangeFunc, initialStateFunc)
	static applyStateChange = function(id, stateChangeFunc, initialStateFunc) {
		var prev_state = document.previous_animation_states[$ id];
		if prev_state == undefined prev_state = initialStateFunc();
		
		var next_state = document.next_animation_states[$ id];
		if next_state == undefined { 
			next_state = prev_state; // or deep copy?
			document.next_animation_states[$ id] = next_state;
		}
		
		// apply the change
		stateChangeFunc(prev_state, next_state);
	}
	
	// a hotspot is any area of cursor interaction (mouse/touch/customcursor)
	/// @func addHotspot(rect, renderer, handler, trace, data, item_index)
	static addHotspot = function(rect, renderer, handler, trace, data, item_index) {
		var ro_context = self;
		var hotspot = {
			trace: trace,
			ro_context: ro_context,
			rect: rect,
			renderer: renderer,
			handler: handler,
			data: data,
			item_index: item_index,
			result: undefined,
		};
		array_push(hotspots, hotspot);
	}
	
	static handleHotspots = function(cursor_state, cursor_event) {
		
		// TODO: run this in reverse order?
		var i = 0; repeat array_length(hotspots) {
			var hotspot = hotspots[i++];				
						
			cursor_state.hover = yui_cursor_in_rect(cursor_state, hotspot.rect);		
			
			//yui_draw_trace_rect(true, hotspot.rect, c_lime);
			yui_draw_trace_rect(hotspot.trace, hotspot.rect, c_lime);
			
			// handle the hotspot
			with (hotspot.renderer) {
				
				// storing this in a variable ensures the handler will be called in scope of the renderer, not the hotspot
				var handler = hotspot.handler;
				
				handler(hotspot, cursor_state, cursor_event);
			}
		}		
	}
	
	/// @func handleAllHotspots()
	/// @description handles all hotspots on the ro_context and any of its overlays
	static handleAllHotspots = function(cursor_state, cursor_event) {
		
		// loop through overlays in reverse order to handle hotspots from the top down
		var popup_count = array_length(overlays);
		var i = popup_count; repeat popup_count {
			var overlay = overlays[--i];

			overlay.ro_context.handleHotspots(cursor_state, cursor_event);						
		}
		
		// handle base hotpsots
		handleHotspots(cursor_state, cursor_event);
		
		// hack until YuiCursorManager hotspot consumption get updated
		var consumed =
			cursor_event.hover_consumed
			|| cursor_event.tooltip_consumed
			|| cursor_event.cursor_press_consumed
			|| cursor_event.cursor_release_consumed
			|| cursor_event.cursor_click_consumed;
		return consumed;
	}
	
	/// @func drawOverlays()	
	static drawOverlays = function() {
		
		// draw any hotspot content from the base layer (TODO: move this somewhere?)
		var count = array_length(hotspots);
		for (var j = 0; j < count; ++j) {
			var hotspot = hotspots[j];
			if hotspot.result {				
				hotspot.result.draw();
			}
		}
		
		var overlay_count = array_length(overlays);
		var i = 0; repeat overlay_count {
			var overlay = overlays[i++];
			
			// draw the overlay
			overlay.popup_result.draw();
				
			// draw any content from hotspots in the overlay (button highlight etc)
			var count = array_length(overlay.ro_context.hotspots);
			for (var j = 0; j < count; ++j) {
				var hotspot = overlay.ro_context.hotspots[j];
				if hotspot.result {
					hotspot.result.draw();
				}
			}				
		}
	}
}

// FUTURE: could move this to a base class?
function yui_instruction(result) {
	result.finalized = false;
	
	with result {
		finalize = function(_x, _y) {
			x += _x;
			y += _y;
		
			var children = variable_struct_get(self, "children");
			if children != undefined {
				var count = array_length(children)
				for (var i = 0; i < count; ++i) {
					var child = children[i];
				
					// skip anything that didn't render
					if child == false continue;
								
					child.finalize(_x + child.panel_position.x, _y + child.panel_position.y);
				}
			}
			else {
				var content = variable_struct_get(self, "content");
				if content {
					content.finalize(_x, _y)
				}
			}
			
			var overlay = variable_struct_get(self, "overlay");
			if overlay != undefined {
				overlay.popup_result.finalize(_x, _y);
			}
			
			finalized = true;
		}
	}
	
	return result;
}