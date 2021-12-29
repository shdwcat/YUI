/// @description renders a YUI Border
function YuiBorderRenderer(_props, _resources, _slot_values) : YuiBaseRenderer(_props, _resources, _slot_values) constructor {
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
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.padding = yui_resolve_padding(props.padding);
	content_renderer = yui_resolve_renderer(props.content, resources, slot_values);

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
	bg_color = yui_resolve_color(props.bg_color);
	border_color = yui_resolve_color(props.border_color);
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_renderer: content_renderer,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		
		// diff
		if prev // currently nothing else is bindable
		{
			return true;
		}
		
		return {
			data_source: data,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
		};
	}
}