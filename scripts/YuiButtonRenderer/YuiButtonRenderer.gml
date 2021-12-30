/// @description renders a YUI Button
function YuiButtonRenderer(_props, _resources, _slot_values) : YuiBaseRenderer(_props, _resources, _slot_values) constructor {
	static default_props = {		
		type: "button",
		theme: "default",
		
		bg_sprite: undefined,
		bg_sprite_size: undefined,
		bg_color: undefined,
		border_color: undefined,
		border_thickness: 1,
		
		padding: undefined, // default to theme value
		
		content: noone,
		fit_to_content: true, // can be true/false/width/height
		scale_mode: "slice", // stretch/tile/clip/none/etc
		
		popup: undefined, // setting popup will show a popup in an overlay				
		tooltip: noone, // either tooltip text or a Binding
		
		mouseover_color: $55555555,
		mousedown_color: $99999999,
		highlight_color: $FFFFFFFF,
		
		enabled: true, // can be bound
		on_click: noone,
		click_button: mb_left,
	}
	
	props = yui_apply_props(_props);
	yui_resolve_theme();
	props.enabled = yui_bind(props.enabled, resources, slot_values);
	
	// TODO fix theme implementation
	var padding = props.padding == undefined ? theme.button.padding : props.padding;
	props.padding = yui_resolve_padding(padding);
	
	content_renderer = yui_resolve_renderer(props.content, resources, slot_values);
	
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
	bg_color = yui_resolve_color(props.bg_color);
	border_color = yui_resolve_color(props.border_color);
	
	props.on_click = yui_resolve_command(props.on_click, resources, slot_values);
	
	// set up popup mode
	if props.popup {
				
		props.popup.type = "popup";
		popup_renderer = yui_resolve_renderer(props.popup, resources, slot_values);	
		
		props.on_click = new YuiMethodCommand(function() {
			return function(prev_state, next_state) {
				next_state.popup_visible = !prev_state.popup_visible;
			}
		});
		
		props.events.on_click_outside = new YuiMethodCommand(function() {
			return function(prev_state, next_state) {				
				next_state.popup_visible = false;
			}
		});
	}
	
	// ===== functions =====
	
	is_bound = yui_is_live_binding(props.enabled);
	
	// TODO: how to inherit these from YuiBorderRenderer?
	
	static getLayoutProps = function() {
		var content = content_renderer;
		if content == noone content = undefined;
		
		return {
			highlight_color: yui_resolve_color(props.highlight_color),
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_type: content_renderer ? content_renderer.props.type : undefined,
			content_renderer: content,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var enabled = yui_resolve_binding(props.enabled, data);
		
		// diff
		if prev
			&& enabled == prev.enabled
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
		};
		
		if props.popup {
			result.popup_renderer = popup_renderer;
		}
		
		return result;
	}
	
	static getInitialAnimationState = function() {
		return { popup_visible: false };
	}
}