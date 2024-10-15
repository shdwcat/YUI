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
	
	props.padding = new YuiPadding(yui_bind(props.padding, resources, slot_values));
	content_element = yui_resolve_element(props.content, resources, slot_values);
	
	resolveBackgroundAndBorder();
	
	is_bound = base_is_bound;
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			content_element: content_element,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
		};
	}
	
	// feather ignore once GM2017
	static getBoundValues = function YuiBorderElement_getBoundValues(data, prev) {
		if props.trace
			DEBUG_BREAK_YUI
		
		// diff
		if prev
			&& data == prev.data_source
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
		};
	}
}