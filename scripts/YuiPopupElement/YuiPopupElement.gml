
function YuiPopupElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "popup",	
		theme: "default",
		
		placement: YUI_PLACEMENT_MODE.BottomRight,
		content: undefined,
		
		// default to theme values
		bg_color: undefined,
		border_color: undefined,
		border_thickness: undefined,		
		padding: undefined,
	}
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.placement = yui_bind(props.placement, resources, slot_values);
	
	// TODO: clean up initializing props from theme
	
	if props.bg_color == undefined {
		props.bg_color = theme.popup.bg_color;
	}
	else {
		props.bg_color = yui_resolve_color(props.bg_color);
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

	is_bound = yui_is_live_binding(props.placement);
	
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
		
		var placement = yui_resolve_binding(props.placement, data);
		
		// diff
		if prev
			&& placement == prev.placement
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			bg_sprite: undefined, // not yet implemented here
			bg_color: props.bg_color,
			border_color: props.border_color,
			border_thickness: props.border_thickness,
			placement: placement,
		};
	}
}