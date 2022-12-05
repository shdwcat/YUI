/// @description renders a YUI Border
function YuiBorderElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "border",
		padding: 0,

		// visuals
		background: undefined,
		border_color: undefined,
		border_thickness: 1,
		border_focus_color: undefined,
		
		// the content to display inside the border
		content: undefined,
	};
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	content_element = yui_resolve_element(props.content, resources, slot_values);
	
	resolveBackgroundAndBorder()
	
	is_bound = base_is_bound
		|| is_bg_sprite_live
		|| is_bg_color_live;
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_element: content_element,
			is_bg_live: is_bg_sprite_live || is_bg_color_live,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
		};
	}
	
	static getBoundValues = function YuiBorderElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
		
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		
		if props.trace
			DEBUG_BREAK_YUI
		
		var bg_sprite = is_bg_sprite_live ? yui_resolve_sprite_by_name(bg_sprite_binding.resolve(data)) : undefined;
		var bg_color = is_bg_color_live ? yui_resolve_color(bg_color_binding.resolve(data)) : undefined;
		
		// diff
		if prev
			&& data == prev.data_source
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
			xoffset: xoffset,
			yoffset: yoffset,
			// live versions
			bg_sprite: bg_sprite,
			bg_color: bg_color,
		};
	}
}