#macro YUI_MAX_INPUT_CHARS 1000

/// @description
function YuiTextInputElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "text_input",
		padding: undefined,
		
		focusable: true,
		
		enabled: true, // can be bound
		max_chars: YUI_MAX_INPUT_CHARS,
		highlight_color: $FFFFFFFF,
		
		// border props
		background: undefined,
		border_color: undefined,
		border_thickness: 1,
		border_focus_color: undefined,
		
		// text props (scribble not supported for text input)
		text: undefined,
		text_style: "body",
		font: undefined, // overrides text_style.font
		color: undefined, // overrides text_style.color
	};
	
	static default_events = {
		on_text_changed: undefined,
	}
	
	props = yui_apply_props(_props);
	
	baseInit(props);
	
	props.events = yui_init_props(props.events, default_events);
	props.events.on_text_changed = yui_bind_handler(props.events.on_text_changed, resources, slot_values);
	
	props.max_chars = min(props.max_chars, YUI_MAX_INPUT_CHARS);
	
	// apply theme defaults
	props.padding ??= theme.text_input.padding;
	props.background ??= theme.text_input.background;
	props.border_color ??= theme.text_input.border_color;
	props.border_thickness ??= theme.text_input.border_thickness;
	props.border_focus_color ??= theme.text_input.border_focus_color;
	
	props.padding = yui_resolve_padding(props.padding);
	
	// resolve slot/resource (not bindable currently)
	var background_expr = yui_bind(props.background, resources, slot_values);
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
	border_focus_color = yui_resolve_color(yui_bind(props.border_focus_color, resources, slot_values));
	
	content_element = yui_resolve_element({
		type: "text",
		alignment: props.alignment,
		text: props.text,
		text_style: props.text_style,
		font: props.font,
		color: props.color,
	}, resources, slot_values);
	
	props.enabled = yui_bind(props.enabled, resources, slot_values);
	
	is_enabled_live = yui_is_live_binding(props.enabled);
	
	is_bound = base_is_bound
		|| yui_is_live_binding(props.enabled);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			// border
			content_element: content_element,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
			// text_input
			max_chars: props.max_chars,
			highlight_color: yui_resolve_color(props.highlight_color),
		};
	}
	
	static getBoundValues = function YuiTextElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = is_data_source_bound ? data_source.resolve(data) : data_source;
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
		
		var opacity = is_opacity_live ? props.opacity.resolve(data) : props.opacity;
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		
		var enabled = is_enabled_live ? props.enabled.resolve(data) : props.enabled;
		
		// diff
		if prev
			&& opacity == prev.opacity
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
			&& enabled == prev.enabled
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			opacity: opacity,
			xoffset: xoffset,
			yoffset: yoffset,
			enabled: enabled,
		};
	}
}

