function YuiBaseRenderer(_props, _resources) constructor {
	static base_props = {
		id: "", // unique ID for this element, required to enabled animations and other effects
		item_key: undefined, // identifies an element in an array (must bind to unique value on data!)
		
		// TODO: define theme here
		
		visible: true,
		size: "auto", // can also be { w: val, h: val } where val can be a number or "auto" | "content"
		
		data_source: noone, // enables overriding the data context with something else
		tooltip: noone, // @bindable tooltip text/content
		tooltip_width : 500,
		tooltip_placement: placement_mode.BottomLeft, // where to place the tooltip
		
		// 'auto' means the root element of a document will consume cursor events in its draw_rect
		cursor_events: YuiCursorEvents.auto, 
		
		trace: false, // enables various debug visuals/breakpoints/logging
				
		events: undefined,
		
		interactions: {}, // these are defined in data!
	};
	
	// common events across elements
	static base_events = {
		on_mouse_down: undefined,
		on_mouse_up: undefined,
		on_click: undefined,
		on_click_outside: undefined,
	};
	
	props = yui_init_props(_props, base_props);
	props.events = yui_init_props(props.events, base_events);
	props.cursor_events = yui_parse_cursor_events_enum(props.cursor_events);
	
	props.visible = yui_bind(props.visible, _resources);
	props.item_key = yui_bind(props.item_key, _resources);
	
	data_source = yui_resolve_data_source(props.data_source, _resources, props.trace);
	
	if props.tooltip != noone {
		var tooltip_element = {
			type: "tooltip",
			content: props.tooltip,
			size: { w: props.tooltip_width, h: "auto" },
		};
		tooltip_renderer = new YuiTooltipRenderer(tooltip_element, _resources);
	}
	
	// The surface_lookup is needed in the case that we're drawing to a surface from within
	// a panel generated from data, as in that case there will only be one renderer for all the items,
	// so naively using a single surface would result in constantly resizing the surface for each item
	// and we'd like to avoid that performance hit
	surface_lookup = noone;
	
	static update = function(ro_context, data, draw_rect, item_index) {
		return false;
	}
	
	/// @func getStateKey(ro_context, data)
	static getStateKey = function(ro_context, data) {
				
		var state_key = props.id;
				
		// item_key can differentiate between buttons with the same ID due to being in a panel
		if props.item_key {
			var item_key = ro_context.resolveBinding(props.item_key, data);
			state_key += "." + item_key;
		}
		
		return state_key;
	}
	
	/// @func handleInteractions(ro_context, data, draw_rect, item_index)
	static handleInteractions = function(ro_context, data, draw_rect, item_index) {
		var interaction = YuiCursorManager.active_interaction;
		if interaction == undefined return;
		
		var participation = props.interactions[$ interaction.props.id];
		if participation == undefined return;
		
		var result = interaction.updateTarget(ro_context, data, draw_rect, participation); // item_index?
		return result;
	}
	
	/// @func pushEventHotspotIfAny(ro_context, hotspot_rect, data, item_index)
	static pushEventHotspotIfAny = function(ro_context, data, hotspot_rect, item_index) {
		// add a hotspot if there is a cursor event to handle
		if variable_struct_exists(props.events, "on_mouse_down")
		|| variable_struct_exists(props.events, "on_mouse_up") {
			ro_context.addHotspot(
				hotspot_rect,
				self,
				onEventHotspot,
				props.trace,
				data,
				item_index);				
		}
	}
	
	static onEventHotspot = function(hotspot, cursor_state, cursor_event) {
		if cursor_state.hover && !cursor_event.cursor_press_consumed {
			var on_mouse_down = props.events[$ "on_mouse_down"];
			if on_mouse_down != undefined {
				var button = on_mouse_down[$ "button"];
				if button == undefined button = mb_left;
				
				if mouse_check_button_pressed(button) {
					var handled = yui_call_event_handler(on_mouse_down, self, hotspot.ro_context, hotspot.data);
					if handled == true {
						cursor_event.cursor_press_consumed = true;
					}
				}
			}
		}			
		else if cursor_state.hover && !cursor_event.cursor_release_consumed {
			var on_mouse_up = props.events[$ "on_mouse_up"];
			if on_mouse_up != undefined {				
				var button = on_mouse_up[$ "button"];
				if button == undefined button = mb_left;
				
				if mouse_check_button_released(button) {
					var handle = yui_call_event_handler(on_mouse_up, self, hotspot.ro_context, hotspot.data);
					if handled == true {
						cursor_event.cursor_release_consumed = true;
					}
				}
			}
		}
	}
		
	static onTooltip = function(hotspot, cursor_state, cursor_event) {
		if cursor_event.tooltip_consumed return;
		
		if cursor_state.hover {
			cursor_event.tooltip_consumed = true;
			yui_render_overlay(
				hotspot.ro_context,
				hotspot.rect,
				props.tooltip_placement,
				tooltip_renderer,
				hotspot.data,
				hotspot.item_index,
				"tooltip_overlay");
		}
	}
	
	static consumeCursorEvents = function(hotspot, cursor_state, cursor_event) {
		if cursor_state.hover {
			cursor_event.hover_consumed = true;
			cursor_event.cursor_press_consumed = true;
			cursor_event.cursor_release_consumed = true;
			cursor_event.cursor_click_consumed = true;
			cursor_event.tooltip_consumed = true;
		}
	}
	
	// draws to a surface instead of the current render target
	// returns the surface and the size of the content that was drawn
	static drawToSurface = function(ro_context, data, draw_rect, item_index, surface_key) {
		
		// TODO: could avoid using the surface lookup in cases where a key is not provided
		// but too lazy to do that for now
		if surface_lookup == noone {			
			yui_log("setting up surface lookup (key", surface_key, ")");
			surface_lookup = {};
		}
		
		// HACKS ==================== TODO fix however we're getting negative values ===========================
		// NOTE: it's padding that doesn't fit in the draw rect (or a panel that doesn't)
		var invalid = false;
		if draw_rect.w <= 0 {
			draw_rect.w = 0;
			invalid = true;
		}
		if draw_rect.h <= 0 {
			draw_rect.h = 0;
			invalid = true;
		}
		if invalid {
			return;
		}
		
		// update data source if needed
		if !is_undefined(data_source) {
			data = data_source;
			// NOTE: why is this done here and not in each renderer that supports data_source?
		}
		
		var surface_target = yui_push_surface_target(draw_rect, surface_lookup, surface_key);		
				
		// reset content draw position to 0,0 since we're in a surface
		var content_draw_rect = {
			x: 0, y: 0,
			w: draw_rect.w, h: draw_rect.h,
		};
				
		// draw the content to the content surface
		var content_result = update(ro_context, data, content_draw_rect, item_index);
		var size = {
			w: content_result.w,
			h: content_result.h,
		};
		content_result.draw();
		
		yui_restore_surface_target(surface_target.old_surface);
			
		return {
			surface: surface_target.content_surface,
			size: size
		};
	}
	
	// DEPRECATED but preserved for reference
	// renders to a surface instead of the current render target
	// returns the surface and the size of the content that was drawn
	static renderToSurface = function(ro_context, draw_rect, surface_key) {
		
		// TODO: could avoid using the surface lookup in cases where a key is not provided
		// but too lazy to do that for now
		if surface_lookup == noone {			
			yui_log("setting up surface lookup (key", surface_key, ")");
			surface_lookup = {};
		}
		
		// HACKS ==================== TODO fix however we're getting negative values ===========================
		// NOTE: it's padding that doesn't fit in the draw rect (or a panel that doesn't)
		var invalid = false;
		if draw_rect.w <= 0 {
			draw_rect.w = 0;
			invalid = true;
		}
		if draw_rect.h <= 0 {
			draw_rect.h = 0;
			invalid = true;
		}
		if invalid {
			return;
		}
		
		// update data source if needed
		// todo: change to ro_context = ro_context.resolveDataSource(data_source)
		if !is_undefined(data_source) {			
			ro_context = ro_context.copy();
			ro_context.data = data_source;
			// NOTE: why is this done here and not in each renderer that supports data_source?
		}
		
		var surface_target = yui_push_surface_target(draw_rect, surface_lookup, surface_key);		
				
		// reset content draw position to 0,0 since we're in a surface
		var content_draw_rect = {
			x: 0, y: 0,
			w: draw_rect.w, h: draw_rect.h,
		};
		
		// draw the content to the content surface
		var content_size = render(ro_context, content_draw_rect);
		var size = {
			w: content_size.w,
			h: content_size.h,
		};
		
		yui_restore_surface_target(surface_target.old_surface);
			
		return {
			surface: surface_target.content_surface,
			size: size
		};
	}
}