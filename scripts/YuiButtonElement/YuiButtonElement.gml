/// @description renders a YUI Button
function YuiButtonElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "button",
		
		focusable: true,
		
		background: undefined,
		border_color: undefined,
		border_thickness: 1,
		border_focus_color: undefined,
		
		padding: undefined, // default to theme value
		
		content: undefined,
		scale_mode: "slice", // stretch/tile/clip/none/etc
		
		popup: undefined, // setting popup will show a popup in an overlay
		
		highlight_color: 0xFFFFFF,
		highlight_alpha: 0.2,
		pressed_alpha: 0.4,
		
		enabled: true, // can be bound
		on_click: undefined,
	}
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	props.enabled = yui_bind(props.enabled, resources, slot_values);
	
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	
	content_element = yui_resolve_element(props.content, resources, slot_values);
	
	resolveBackgroundAndBorder()
	
	props.highlight_color = yui_bind_and_resolve(props.highlight_color, resources, slot_values);
	props.highlight_alpha = yui_bind(props.highlight_alpha, resources, slot_values);
	props.pressed_alpha = yui_bind(props.pressed_alpha, resources, slot_values);
	
	// set up popup mode
	if props.popup {
		props.popup.type = "popup";
		popup_element = yui_resolve_element(props.popup, resources, slot_values);
	}
	
	props.on_click = yui_bind_handler(props.on_click, resources, slot_values);
	
	is_enabled_live = yui_is_live_binding(props.enabled);
	
	is_bound = base_is_bound
		|| yui_is_live_binding(props.enabled);
		
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
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
		};
	}
	
	static getBoundValues = function YuiButtonElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
		
		var opacity = is_opacity_live ? props.opacity.resolve(data) : props.opacity;
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		
		var enabled = is_enabled_live ? props.enabled.resolve(data) : props.enabled;
		
		// diff
		if prev
			&& data == prev.data_source
			&& enabled == prev.enabled
			&& opacity == prev.opacity
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
		{
			return true;
		}
		
		//if props.trace
		//	DEBUG_BREAK_YUI;
				
		var result = {
			is_live: is_bound,
			data_source: data,
			opacity: opacity,
			xoffset: xoffset,
			yoffset: yoffset,
			enabled: enabled,
		};
		
		if props.popup {
			result.popup_element = popup_element;
		}
		
		return result;
	}
}