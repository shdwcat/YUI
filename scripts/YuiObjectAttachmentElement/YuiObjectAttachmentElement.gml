/// @description here
function YuiObjectAttachmentElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "object_attachment",
		padding: 0,
		
		// the target to attach to
		target: undefined,
		
		placement: undefined, // how to position relative to the target
		
		// the content to display
		content: undefined,
	};
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	content_element = yui_resolve_element(props.content, _resources, _slot_values);
	
	target = yui_bind(props.target, _resources, _slot_values);
	placement = yui_read_placement_mode(yui_bind(props.placement, resources, slot_values));
	
	is_bound = base_is_bound
		|| yui_is_live_binding(target);
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		return {
			padding,
			size,
			content_element,
		};
	}
	
	static getBoundValues = function YuiBorderElement_getBoundValues(data, prev) {
		
		// diff
		if prev
		{
			return true;
		}
		
		return {
			is_live: is_bound,
		};
	}
}