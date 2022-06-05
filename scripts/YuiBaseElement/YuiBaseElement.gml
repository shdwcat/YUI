function YuiBaseElement(_props, _resources, _slot_values) constructor {
	static base_props = {
		id: "", // unique ID for this element, required to enabled animations and other effects
		item_key: undefined, // identifies an element in an array (must bind to unique value on data!)
		
		theme: "default",
		
		layer: 0, // offset to apply to the layer depth
		is_cursor_layer: false, // whether the element consumes cursor events
		focusable: false, // whether the item can be focused for kb/gamepad
		autofocus: false, // whether to auto focus this item on creation (overrides previous focus)
		
		data_source: undefined, // enables overriding the data context with something else
		
		visible: true,
		opacity: 1, // 0-1, like alpha
		size: "auto", // can also be { w: val, h: val } where val can be a number or "auto" | "content"
		alignment: "default",
		canvas: undefined,
		xoffset: 0,
		yoffset: 0,
		
		tooltip: undefined, // @bindable tooltip text/content
		tooltip_width : 500,
		tooltip_placement: YUI_PLACEMENT_MODE.BottomLeft, // where to place the tooltip
		
		trace: false, // enables various debug visuals/breakpoints/logging
		
		events: undefined,
		
		// array of interaction.role participation
		interactions: [], // these are defined in data!
	};
	
	// common events across elements
	static base_events = {
		on_mouse_down: undefined,
		on_mouse_up: undefined,
		on_mouse_wheel_up: undefined,
		on_mouse_wheel_down: undefined,
		on_click: undefined,
		on_arrange: undefined,
		on_got_focus: undefined,
		on_lost_focus: undefined,
	};
	
	// this is the type from the .yui declaration which may be a template or fragment name
	yui_type = _props.yui_type; // TODO: string hash this for faster comparison
	
	resources = _resources;
	slot_values = _slot_values;
	
	// resolve theme first so it can be used in yui_apply_props
	theme = yui_resolve_theme(_props[$ "theme"]);
	
	// get the theme props for our type (applies template/fragment type first)
	element_theme = theme.elements[$ yui_type] ?? theme.elements[$ _props.type];
	
	static baseInit = function(props, default_events = undefined) {
	
		props.events = yui_apply_props(props.events, default_events, base_events);
		props.events.on_mouse_down = yui_bind_handler(props.events.on_mouse_down, resources, slot_values);
		props.events.on_mouse_up = yui_bind_handler(props.events.on_mouse_up, resources, slot_values);
		props.events.on_mouse_wheel_up = yui_bind_handler(props.events.on_mouse_wheel_up, resources, slot_values);
		props.events.on_mouse_wheel_down = yui_bind_handler(props.events.on_mouse_wheel_down, resources, slot_values);
		props.events.on_click = yui_bind_handler(props.events.on_click, resources, slot_values);
		props.events.on_arrange = yui_bind_handler(props.events.on_arrange, resources, slot_values);
	
		YuiCursorManager.participation_hash.hashArray(props.interactions);
	
		size = new YuiElementSize(yui_bind(props.size, resources, slot_values));
		size.w = yui_bind(size.w, resources, slot_values);
		size.h = yui_bind(size.h, resources, slot_values);
	
		canvas = new YuiCanvasPosition(props.canvas, resources, slot_values, props.id);
	
		// TODO: move this to YuiPanelElement?
		alignment = new YuiElementAlignment(yui_bind(props.alignment, resources, slot_values));
		
		props.visible = yui_bind(props.visible, resources, slot_values);
		props.opacity = yui_bind(props.opacity, resources, slot_values);
		props.item_key = yui_bind(props.item_key, resources, slot_values);
		props.tooltip = yui_bind(props.tooltip, resources, slot_values);
	
		props.xoffset = yui_bind(props.xoffset, resources, slot_values);
		props.yoffset = yui_bind(props.yoffset, resources, slot_values);
	
		data_source = yui_bind(props.data_source, resources, slot_values);
	
		is_data_source_bound = yui_is_live_binding(data_source);
		is_visible_live = yui_is_live_binding(props.visible);
		is_opacity_live = yui_is_live_binding(props.opacity);
		is_tooltip_live = yui_is_live_binding(props.tooltip);
		is_xoffset_live = yui_is_live_binding(props.xoffset);
		is_yoffset_live = yui_is_live_binding(props.yoffset);
	
		base_is_bound = yui_is_live_binding(data_source)
			|| is_visible_live
			|| is_opacity_live
			|| is_tooltip_live
			|| yui_is_live_binding(props.size)
			|| yui_is_live_binding(size.w)
			|| yui_is_live_binding(size.h)
			|| is_xoffset_live
			|| is_yoffset_live;
	
		tooltip_element = undefined;
		if props.tooltip != undefined {
			var tooltip_props = {
				type: "popup",
				yui_type: "popup",
				content: props.tooltip,
				placement: props.tooltip_placement,
				size: { max_w: props.tooltip_width },
			};
			tooltip_element = new YuiPopupElement(tooltip_props, resources, slot_values);
		}
	}
}