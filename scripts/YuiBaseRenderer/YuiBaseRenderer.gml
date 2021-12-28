function YuiBaseRenderer(_props, _resources, _slot_values) constructor {
	static base_props = {
		id: "", // unique ID for this element, required to enabled animations and other effects
		item_key: undefined, // identifies an element in an array (must bind to unique value on data!)
		
		// TODO: define theme here
		
		visible: true,
		size: "auto", // can also be { w: val, h: val } where val can be a number or "auto" | "content"
		alignment: "default",
		canvas: undefined,
		
		data_source: undefined, // enables overriding the data context with something else
		tooltip: undefined, // @bindable tooltip text/content
		tooltip_width : 500,
		tooltip_placement: placement_mode.BottomLeft, // where to place the tooltip
				
		trace: false, // enables various debug visuals/breakpoints/logging
				
		events: undefined,
		
		// array of interaction.role participation
		interactions: [], // these are defined in data!
	};
	
	// common events across elements
	static base_events = {
		on_mouse_down: undefined,
		on_mouse_up: undefined,
		on_click: undefined,
		on_click_outside: undefined,
	};
	
	resources = _resources;
	slot_values = _slot_values;
	
	props = yui_init_props(_props, base_props);
	type = props._type; // TODO: string hash this for faster comparison
	
	props.events = yui_init_props(props.events, base_events);
	props.events.on_mouse_down = yui_resolve_command(props.events.on_mouse_down, resources, slot_values);
	props.events.on_mouse_up = yui_resolve_command(props.events.on_mouse_up, resources, slot_values);
	props.events.on_click = yui_resolve_command(props.events.on_click, resources, slot_values);
	props.events.on_click_outside = yui_resolve_command(props.events.on_click_outside, resources, slot_values);
	YuiCursorManager.participation_hash.hashArray(props.interactions);
	
	size = new YuiElementSize(yui_bind(props.size, resources, slot_values));
	canvas = new YuiCanvasPosition(yui_bind(props.canvas, resources, slot_values));
	
	// move this to YuiPanelRenderer
	alignment = new YuiElementAlignment(yui_bind(props.alignment, resources, slot_values));
		
	props.visible = yui_bind(props.visible, resources, slot_values);
	props.item_key = yui_bind(props.item_key, resources, slot_values);
	props.tooltip = yui_bind(props.tooltip, resources, slot_values);
	
	data_source = yui_bind(props.data_source, resources, slot_values);
	
	tooltip_renderer = undefined;
	if props.tooltip != undefined {
		var tooltip_props = {
			type: "popup",
			_type: "popup",
			content: props.tooltip,
			placement: props.tooltip_placement,
			size: { max_w: props.tooltip_width },
		};
		tooltip_renderer = new YuiPopupRenderer(tooltip_props, resources, slot_values);
	}
	
	/// @func getStateKey(ro_context, data)
	static getStateKey = function(ro_context, data) {
				
		var state_key = props.id;
				
		// item_key can differentiate between buttons with the same ID due to being in a panel
		if props.item_key {
			var item_key = yui_resolve_binding(props.item_key, data);
			state_key += "." + item_key;
		}
		
		return state_key;
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
}