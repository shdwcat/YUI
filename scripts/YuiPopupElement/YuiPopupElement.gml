
function YuiPopupElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "popup",
		padding: undefined,
		
		placement: YUI_PLACEMENT_MODE.BottomRight,
		content: undefined,
		
		background: undefined,
		border_color: undefined,
		border_thickness: undefined,
	}
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	props.placement = yui_read_placement_mode(yui_bind(props.placement, resources, slot_values));
	
	resolveBackgroundAndBorder()
	
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	
	content_element = yui_resolve_element(props.content, resources, slot_values);

	is_bound = base_is_bound
		|| is_bg_sprite_live
		|| is_bg_color_live
		|| yui_is_live_binding(props.placement);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_element: content_element,
			// border
			is_bg_live: is_bg_sprite_live || is_bg_color_live,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			// not supported
			border_focus_color: undefined,
		};
	}
	
	static getBoundValues = function YuiPopupElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var placement = yui_resolve_binding(props.placement, data);
		var xoffset = yui_resolve_binding(props.xoffset, data);
		var yoffset = yui_resolve_binding(props.yoffset, data);
		
		var bg_sprite = is_bg_sprite_live ? yui_resolve_sprite_by_name(bg_sprite_binding.resolve(data)) : undefined;
		var bg_color = is_bg_color_live ? yui_resolve_color(bg_color_binding.resolve(data)) : undefined;
		
		// diff
		if prev
			&& data == prev.data_source
			&& placement == prev.placement
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
			&& bg_sprite == prev.bg_sprite
			&& bg_color == prev.bg_color
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			// popup
			placement: placement,
			xoffset: xoffset,
			yoffset: yoffset,
			// live versions
			bg_sprite: bg_sprite,
			bg_color: bg_color,
		};
	}
}