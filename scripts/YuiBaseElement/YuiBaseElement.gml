function YuiBaseElement(_props, _resources, _slot_values) constructor {
	static base_props = {
		id: "", // unique ID for this element, required to enabled animations and other effects
		item_key: undefined, // identifies an element in an array (must bind to unique value on data!)
		
		// TODO: define theme here
				
		focusable: false, // whether the item can be focused for kb/gamepad
		autofocus: false, // whether to auto focus this item on creation (overrides previous focus)
		
		data_source: undefined, // enables overriding the data context with something else
		
		visible: true,
		opacity: 1, // 0-1, like alpha
		size: "auto", // can also be { w: val, h: val } where val can be a number or "auto" | "content"
		alignment: "default",
		canvas: undefined,
		
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
		on_click: undefined,
		on_click_outside: undefined,
	};
	
	resources = _resources;
	slot_values = _slot_values;
	
	props = yui_init_props(_props, base_props);
	type = props._type; // TODO: string hash this for faster comparison
	
	props.events = yui_init_props(props.events, base_events);
	props.events.on_mouse_down = yui_bind_handler(props.events.on_mouse_down, resources, slot_values);
	props.events.on_mouse_up = yui_bind_handler(props.events.on_mouse_up, resources, slot_values);
	props.events.on_click = yui_bind_handler(props.events.on_click, resources, slot_values);
	props.events.on_click_outside = yui_bind_handler(props.events.on_click_outside, resources, slot_values);
	
	YuiCursorManager.participation_hash.hashArray(props.interactions);
	
	size = new YuiElementSize(yui_bind(props.size, resources, slot_values));
	
	var canvas_binding = yui_bind(props.canvas, resources, slot_values);
	canvas = new YuiCanvasPosition(canvas_binding, resources, slot_values);
	
	// TODO: move this to YuiPanelElement?
	alignment = new YuiElementAlignment(yui_bind(props.alignment, resources, slot_values));
		
	props.visible = yui_bind(props.visible, resources, slot_values);
	props.opacity = yui_bind(props.opacity, resources, slot_values);
	props.item_key = yui_bind(props.item_key, resources, slot_values);
	props.tooltip = yui_bind(props.tooltip, resources, slot_values);
	
	data_source = yui_bind(props.data_source, resources, slot_values);
	
	base_is_bound = yui_is_live_binding(props.data_source)
		|| yui_is_live_binding(props.visible)
		|| yui_is_live_binding(props.opacity)
		|| yui_is_live_binding(props.tooltip)
		|| yui_is_live_binding(props.size)
		|| yui_is_live_binding(props.canvas);
	
	tooltip_element = undefined;
	if props.tooltip != undefined {
		var tooltip_props = {
			type: "popup",
			_type: "popup",
			content: props.tooltip,
			placement: props.tooltip_placement,
			size: { max_w: props.tooltip_width },
		};
		tooltip_element = new YuiPopupElement(tooltip_props, resources, slot_values);
	}
}