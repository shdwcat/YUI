
function YuiPopupElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "popup",
		padding: undefined,
		
		placement: YUI_PLACEMENT_MODE.BottomRight,
		content: undefined,
		
		// popups default to being a cursor layer
		is_cursor_layer: true,
		
		background: undefined,
		border_color: undefined,
		border_thickness: undefined,
	}
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	placement = yui_read_placement_mode(yui_bind(props.placement, resources, slot_values));
	
	resolveBackgroundAndBorder();
	
	content_element = yui_resolve_element(props.content, resources, slot_values);

	is_bound = base_is_bound
		|| yui_is_live_binding(placement);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			alignment,
			padding,
			size: size,
			content_element,
			// border
			border_color,
			border_thickness: props.border_thickness,
			// not supported
			border_focus_color: undefined,
		};
	}
	
	// feather ignore once GM2017
	static getBoundValues = function YuiPopupElement_getBoundValues(data, prev) {
		var placement = yui_resolve_binding(self.placement, data);

		// diff
		if prev
			&& data == prev.data_source
			&& placement == prev.placement
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			// popup
			placement: placement,
		};
	}
}