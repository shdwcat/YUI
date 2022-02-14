/// @description renders a YUI Button
function YuiButtonElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {		
		type: "button",
		theme: "default",
		
		focusable: true,
		
		bg_sprite: undefined,
		bg_sprite_size: undefined,
		bg_color: undefined,
		border_color: undefined,
		border_thickness: 1,
		
		padding: undefined, // default to theme value
		
		content: undefined,
		fit_to_content: true, // can be true/false/width/height
		scale_mode: "slice", // stretch/tile/clip/none/etc
		
		popup: undefined, // setting popup will show a popup in an overlay				
		tooltip: undefined, // either tooltip text or a Binding
		
		mouseover_color: $55555555,
		mousedown_color: $99999999,
		highlight_color: $FFFFFFFF,
		
		enabled: true, // can be bound
		on_click: undefined,
		click_button: mb_left,
	}
	
	props = yui_apply_props(_props);
	yui_resolve_theme();
	props.enabled = yui_bind(props.enabled, resources, slot_values);
	
	// TODO: fix prop application order
	props.focusable = true;
	
	// TODO fix theme implementation
	var padding = props.padding == undefined ? theme.button.padding : props.padding;
	props.padding = yui_resolve_padding(padding);
	
	content_element = yui_resolve_element(props.content, resources, slot_values);
	
	var use_theme_bg = props.bg_sprite == undefined && props.bg_color == undefined;
	if use_theme_bg {
		bg_sprite = theme.button.bg_sprite;
	}
	else if props.bg_sprite != undefined {
		bg_sprite = yui_resolve_sprite_by_name(props.bg_sprite, _resources);
	}
	else {
		bg_sprite = undefined;
	}
	
	// resolve color
	bg_color = yui_resolve_color(yui_bind(props.bg_color, resources, slot_values));
	border_color = yui_resolve_color(yui_bind(props.border_color, resources, slot_values));
	
	// set up popup mode
	if props.popup {				
		props.popup.type = "popup";
		popup_element = yui_resolve_element(props.popup, resources, slot_values);
	}
	
	props.on_click = yui_bind_handler(props.on_click, resources, slot_values);
	
	// ===== functions =====
	
	is_bound = base_is_bound
		|| yui_is_live_binding(props.enabled);
	
	// TODO: how to inherit these from YuiBorderElement?
	
	static getLayoutProps = function() {
		var content = content_element;
		
		return {
			highlight_color: yui_resolve_color(props.highlight_color),
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_type: content_element ? content_element.props.type : undefined,
			content_element: content,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var enabled = yui_resolve_binding(props.enabled, data);
		var opacity = yui_resolve_binding(props.opacity, data);
		
		// diff
		if prev
			&& enabled == prev.enabled
			&& opacity == prev.opacity
		{
			return true;
		}
				
		var result = {
			is_live: is_bound,
			data_source: data,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			enabled: enabled,
			opacity: opacity,
		};
		
		if props.popup {
			result.popup_element = popup_element;
		}
		
		return result;
	}
	
	static getInitialAnimationState = function() {
		return { popup_visible: false };
	}
}