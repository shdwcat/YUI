/// @description renders a YUI Panel
function YuiPanelRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		data_type: noone,
		type: "panel",
				
		// layout
		layout: "vertical",
		padding: 0,
		spacing: noone,
		alignment: "default",
		// alignment is a struct with two properties:
		// .vertical:"top"|"bottom"|"stretch" - "center" not yet supported
		// .horizontal:"left"|"right"|"stretch" - "center" not yet supported
		
		// visuals
		bg_sprite: noone,
		bg_color: noone,
		border_color: noone,
		border_thickness: 1,	
		theme: "default",
		
		// option A: explicitly list the elements in the panel
		elements: noone,
		
		// option B: bind the element list to data, and use a template to render each element
		path: noone, // defines the source path for the element list
		template: noone, // the template to use when rendering elements from the path
	};
	
	props = init_props_old(_props);
	yui_resolve_theme();
	yui_resolve_layout();
	props.path = yui_bind({ path: props.path }, _resources);
	
	size = new YuiElementSize(props.size);
	spacing = props.spacing == noone ? theme.panel.spacing : props.spacing;
	
	// resolve bg_sprite
	var use_theme = props.bg_sprite == noone && props.bg_color == noone;
	if use_theme {
		bg_sprite = noone;
		//bg_sprite = theme.button.bg_sprite;
	}
	else if props.bg_sprite != noone {
		bg_sprite = yui_resolve_sprite_by_name(props.bg_sprite, _resources);
	}
	else {
		bg_sprite = noone;
	}
	
	// resolve colors
	bg_color = yui_resolve_color(props.bg_color);
	border_color = yui_resolve_color(props.border_color);
	
	if props.elements != noone {		
		// generate item_renderers if we have explicit elements
		item_renderers = [];
		var i = 0; repeat array_length(props.elements) {
			var element = props.elements[i];
			var panel_item_id = props.id + "[" + string(i) + "]";
			item_renderers[i] = yui_resolve_renderer(element, _resources, panel_item_id);
			i++;
		}
		data_count = i;
	}
	else {
		item_renderer = yui_resolve_renderer(props.template, _resources, props.id+ ":T");
	}
	
	// The panel_surface_lookup is needed in the case that we're drawing to a surface from within
	// a panel generated from data, as in that case there will only be one renderer for all the items,
	// so naively using a single surface would result in constantly resizing the surface for each item
	// and we'd like to avoid that performance hit.
	panel_surface_lookup = noone;
	
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
		
		if props.trace {
			var foo = "f";
		}

		if data_source != undefined {
			if instanceof(data_source) == "YuiBinding" {
				data = ro_context.resolveBinding(data_source, data);
			}
			else {
				data = data_source;
			}
		}
		
		var is_visible = ro_context.resolveBinding(props.visible, data);
		if !is_visible return false;
		
		// initialize the layout with relevant info
		layout = new makeLayout();
		
		// returned draw_rect will be adjusted to account for size
		draw_rect = layout.init(draw_rect, size, props, true);		
				
		if props.template != noone {
			// TODO: convert elements to use binding
			// template mode uses a single renderer for all items in a bound path
			var data_items = ro_context.resolveBinding(props.path, data);
			
			// NOTE TODO: can gain perf here by converting 'quality list' to array at the data level
			// which is likely what I want to do anyway
			
			// if the value resolves to a snap struct with ordering information, treat it as a list of key-value pairs
			if is_struct(data_items) {
				var field_order = data_items[$ "__snap_field_order"];
				if field_order != undefined {
					var field_count = array_length(field_order);
					var entries = array_create(field_count);
					var i = 0; repeat field_count {
						var key = field_order[i];
						var value = data_items[$ key]; 
						entries[i] = {
							key: key,
							value: value,
						};
						i++;
					}
					data_items = entries;
				}
				else {
					yui_error("Error: value for 'elements' prop did not resolve to an array or iterable struct!");
				}
			}
			
			data_count = array_length(data_items);
		}
		
		var children = array_create(data_count);
		
		var i = 0; repeat data_count {
			if props.template != noone {
				var item_data = data_items[i];
				var renderer = item_renderer;
			}
			else {
				var item_data = data;
				var renderer = item_renderers[i];
			}
			
			if props.trace {
				var foo = "f";
			}
			
			// get the available size for the child
			var item_draw_rect = layout.getItemDrawRect(i, renderer.props);
		
			// update item index for data bound elements list
			if props.template != noone && data_count > 1 {
				item_index = i;
			}
						
			var item_update_result = renderer.update(ro_context, item_data, item_draw_rect, item_index);			
			children[i] = item_update_result;
						
			// have the layout update its internal data
			if item_update_result != false {
				item_update_result.panel_position = {
					x: 0,
					y: 0,
					needs_finalize: false
				};
				
				// TODO: break from loop when should_continue = false
				var should_continue = layout.update(item_update_result, spacing);
				
				// NOTE: this will cause multiple walks with nested offset panels
				// possible we can just link panels with offsets and finalize at the end?
				// would need to somehow detect if we're in an offset panel already
				if item_update_result.panel_position.needs_finalize {
					item_update_result.finalize(
						item_update_result.panel_position.x,
						item_update_result.panel_position.y);
				}
			}
			
			i++;
		}
		
		var draw_size = layout.complete(children, spacing);
				
		var panel_renderer = self;
		var result = yui_instruction({
			x: draw_rect.x,
			y: draw_rect.y,
			w: draw_size.w,
			h: draw_size.h,
			
			children: children,
			renderer: panel_renderer,
			trace: props.trace,
			
			draw: function() {
				renderer.drawBackground(self);
				var count = array_length(children);
				for (var i = 0; i < count; ++i) {
					var child = children[i];
					
					// skip anything that didn't render
					if child == false continue;
					
				    child.draw();
				}
				renderer.drawBorder(self);
				
				// this is the result from participation, e.g. a drop indicator
				if interaction_result {
					interaction_result.draw();
				}
				
				yui_draw_trace_rect(trace, self, c_red);
			}
		});
		
		// TODO figure out how to make this easier
		result.interaction_result = handleInteractions(ro_context, data, result, item_index);
		
		yui_render_tooltip_if_any(ro_context, result, props, data, item_index);		
		pushEventHotspotIfAny(ro_context, data, result, item_index);
		
		if (props.cursor_events == YuiCursorEvents.consume_all) {
			ro_context.addHotspot(result, self, consumeCursorEvents, props.trace, data, item_index);
		}
		
		return result;
	}
			
	static drawBackground = function(draw_rect) {
		if bg_sprite != noone {			
			draw_sprite_stretched(bg_sprite, 0, draw_rect.x, draw_rect.y, draw_rect.w, draw_rect.h);
		}
		else if bg_color != noone {			
			draw_rectangle_color(
				draw_rect.x, draw_rect.y,
				draw_rect.x + draw_rect.w - 1, draw_rect.y + draw_rect.h - 1,
				bg_color, bg_color, bg_color, bg_color, false);
		}
	}
	
	static drawBorder = function(draw_rect) {
		// draw border
		if border_color != noone {
			if props.border_thickness > 0 {				
				yui_draw_rect_outline(
					draw_rect.x, draw_rect.y, draw_rect.w, draw_rect.h,
					props.border_thickness, border_color);
			}
		}
	}
}