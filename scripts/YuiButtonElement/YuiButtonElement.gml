/// @description renders a YUI Button
function YuiButtonElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "button",
		
		focusable: true,
		
		background: undefined,
		border_color: undefined,
		border_thickness: 1,
		border_focus_color: undefined,
		
		padding: undefined,
		
		content: undefined,
		
		popup: undefined, // setting popup will show a popup in an overlay
		
		highlight_color: 0xFFFFFF,
		highlight_alpha: 0.2,
		pressed_alpha: 0.4,
		
		enabled: true, // can be bound
		on_click: undefined,
	}
	
	if _props[$ "trace"] == true
		DEBUG_BREAK_YUI
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	props.padding = new YuiPadding(yui_bind(props.padding, resources, slot_values));
	
	// Feather disable once GM1041
	content_element = yui_resolve_element(props.content, resources, slot_values);
	
	resolveBackgroundAndBorder();
	
	props.highlight_color = yui_bind_and_resolve(props.highlight_color, resources, slot_values);
	props.highlight_alpha = yui_bind(props.highlight_alpha, resources, slot_values);
	props.pressed_alpha = yui_bind(props.pressed_alpha, resources, slot_values);
	
	// set up popup mode
	if props.popup {
		props.popup.type = "popup";
		// Feather disable once GM1041
		popup_element = yui_resolve_element(props.popup, resources, slot_values);
	}
	
	props.on_click = yui_bind_handler(props.on_click, resources, slot_values);
	
	is_bound = base_is_bound;
		
	// ===== functions =====
	
	// TODO: how to inherit these from YuiBorderElement?
	
	static getLayoutProps = function() {
		var content = content_element;
		
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			highlight_color: yui_resolve_color(props.highlight_color),
			highlight_alpha: props.highlight_alpha,
			pressed_alpha: props.pressed_alpha,
			// border
			content_element: content,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
		};
	}
	
	// feather ignore once GM2017
	static getBoundValues = function YuiButtonElement_getBoundValues(data, prev) {
		//if props.trace
		//	DEBUG_BREAK_YUI
		
		// diff
		if prev
			&& data == prev.data_source
		{
			return true;
		}
		
		//if props.trace
		//	DEBUG_BREAK_YUI;
				
		var result = {
			is_live: is_bound,
			data_source: data,
		};
		
		if props.popup {
			result.popup_element = popup_element;
		}
		
		return result;
	}
}