/// @description renders a YUI Button
function YuiButtonElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {		
		type: "button",
		theme: "default",
		
		focusable: true,
		
		background: undefined,
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
	
	// resolve slot/resource (not bindable currently)
	var background_expr = yui_bind(props.background, resources, slot_values)
		?? theme.button.background;
		
	if background_expr != undefined {
		var bg_spr = yui_resolve_sprite_by_name(background_expr);
		if bg_spr != undefined {
			bg_sprite = bg_spr;
			bg_color = undefined;
		}
		else {
			bg_color = yui_resolve_color(background_expr);
			bg_sprite = undefined;
		}
	}
	else {
		bg_color = undefined;
		bg_sprite = undefined;
	}
	
	border_color = yui_resolve_color(yui_bind(props.border_color, resources, slot_values));
	
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
			highlight_color: yui_resolve_color(props.highlight_color),
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_type: content_element ? content_element.props.type : undefined,
			content_element: content,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
		};
	}
	
	static getBoundValues = function(data, prev) {
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