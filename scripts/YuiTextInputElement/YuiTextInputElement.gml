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
		commit_on_lost_focus: true,
		
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
	
	props = yui_apply_element_props(_props);
	
	baseInit(props, default_events);
	
	props.events.on_text_changed = yui_bind_handler(props.events.on_text_changed, resources, slot_values);
	
	props.max_chars = min(props.max_chars, YUI_MAX_INPUT_CHARS);
	
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	
	resolveBackgroundAndBorder()
	
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
		|| is_bg_sprite_live
		|| is_bg_color_live
		|| is_enabled_live;
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			// border
			content_element: content_element,
			is_bg_live: is_bg_sprite_live || is_bg_color_live,
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
			data = is_data_source_live ? data_source.resolve(data) : data_source;
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
		
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		
		var enabled = is_enabled_live ? props.enabled.resolve(data) : props.enabled;
		
		var bg_sprite = is_bg_sprite_live ? yui_resolve_sprite_by_name(bg_sprite_binding.resolve(data)) : undefined;
		var bg_color = is_bg_color_live ? yui_resolve_color(bg_color_binding.resolve(data)) : undefined;
		
		// diff
		if prev
			&& data == prev.data_source
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
			&& bg_sprite == prev.bg_sprite
			&& bg_color == prev.bg_color
			&& enabled == prev.enabled
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			xoffset: xoffset,
			yoffset: yoffset,
			enabled: enabled,
			// live versions
			bg_sprite: bg_sprite,
			bg_color: bg_color,
		};
	}
}



