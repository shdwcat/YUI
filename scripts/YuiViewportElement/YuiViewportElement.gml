/// @description
function YuiViewportElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "viewport",

		// visuals
		background: undefined,
		border_color: undefined,
		border_thickness: 1,
		border_focus_color: undefined,
		
		// offset within the viewport to render the contents at
		viewport_x: 0,
		viewport_y: 0,
		
		// size of the contained content
		content_w: infinity,
		content_h: infinity,
		
		// where to send viewport info (for scrollbar sizes etc)
		on_viewport_info: undefined,
		
		// the content to display inside the viewport
		content: undefined,
	};
	
	props = yui_init_props(_props);
	
	content_element = yui_resolve_element(props.content, resources, slot_values);
	
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
	
	props.on_viewport_info = yui_bind_handler(props.on_viewport_info, resources, slot_values);
	
	props.viewport_x = yui_bind(props.viewport_x, resources, slot_values);
	props.viewport_y = yui_bind(props.viewport_y, resources, slot_values);
	
	// supports slots etc but not live binding
	props.content_w = yui_bind(props.content_w, resources, slot_values);
	props.content_h = yui_bind(props.content_h, resources, slot_values);
	
	is_viewport_x_bound = yui_is_live_binding(props.viewport_x);
	is_viewport_y_bound = yui_is_live_binding(props.viewport_y);
	
	is_bound = base_is_bound
		|| is_viewport_x_bound
		|| is_viewport_y_bound;
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		return {
			// base
			alignment: alignment,
			size: size,
			// border
			content_element: content_element,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
			// viewport
			content_w: props.content_w,
			content_h: props.content_h,
			on_viewport_info: props.on_viewport_info,
		};
	}
	
	static getBoundValues = function YuiViewportElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
		
		var opacity = is_opacity_live ? props.opacity.resolve(data) : props.opacity;
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		var viewport_x = is_viewport_x_bound ? props.viewport_x.resolve(data) : props.viewport_x;
		var viewport_y = is_viewport_y_bound ? props.viewport_y.resolve(data) : props.viewport_y;
		
		// diff
		if prev
			&& opacity == prev.opacity
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
			&& viewport_x == prev.viewport_x
			&& viewport_y == prev.viewport_y
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			opacity: opacity,
			xoffset: xoffset,
			yoffset: yoffset,
			viewport_x: viewport_x,
			viewport_y: viewport_y,
		};
	}
}



