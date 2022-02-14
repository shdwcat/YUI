/// @description renders a YUI Border
function YuiBorderElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "border",

		// visuals
		theme: "default",
		bg_sprite: undefined,
		bg_color: undefined,
		border_color: undefined,
		border_thickness: 1,	
		padding: 0,
		
		// the content to display inside the border
		content: undefined,
	};
	
	props = yui_init_props(_props);
	yui_resolve_theme();
	
	props.padding = yui_resolve_padding(props.padding);
	content_element = yui_resolve_element(props.content, resources, slot_values);

	// resolve bg_sprite
	var use_theme = props.bg_sprite == undefined && props.bg_color == undefined;
	if use_theme {
		bg_sprite = undefined;
		//bg_sprite = theme.button.bg_sprite;
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
	
	is_bound = base_is_bound;
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_element: content_element,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var opacity = yui_resolve_binding(props.opacity, data);
		
		// diff
		if prev
			&& opacity == prev.opacity
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			opacity: opacity,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
		};
	}
}