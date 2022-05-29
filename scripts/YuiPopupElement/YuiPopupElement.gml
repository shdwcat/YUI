
function YuiPopupElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "popup",
		
		placement: YUI_PLACEMENT_MODE.BottomRight,
		content: undefined,
		
		// default to theme values
		background: undefined,
		border_color: undefined,
		border_thickness: undefined,
		padding: undefined,
	}
	
	props = yui_init_props(_props);
	
	props.placement = yui_bind(props.placement, resources, slot_values);
	
	// TODO: clean up initializing props from theme
	if props.background == undefined {
		props.background = theme.popup.background;
	}
	
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
	
	if props.border_color == undefined {
		props.border_color = theme.popup.border_color;
	}
	else {
		props.border_color = yui_resolve_color(props.border_color);
	}
	
	if props.border_thickness == undefined {
		props.border_thickness = theme.popup.border_thickness;
	}
	if props.padding == undefined {
		props.padding = theme.popup.padding;
	}
	props.padding = yui_resolve_padding(props.padding)
	
	content_element = yui_resolve_element(props.content, resources, slot_values);

	is_bound = base_is_bound
		|| yui_is_live_binding(props.placement);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_element: content_element,
			// border
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: props.border_color,
			border_thickness: props.border_thickness,
		};
	}
	
	static getBoundValues = function YuiPopupElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var opacity = yui_resolve_binding(props.opacity, data);
		var placement = yui_resolve_binding(props.placement, data);
		var xoffset = yui_resolve_binding(props.xoffset, data);
		var yoffset = yui_resolve_binding(props.yoffset, data);
		
		// diff
		if prev
			&& opacity == prev.opacity
			&& placement == prev.placement
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			// popup
			opacity: opacity,
			placement: placement,
			xoffset: xoffset,
			yoffset: yoffset,
		};
	}
}