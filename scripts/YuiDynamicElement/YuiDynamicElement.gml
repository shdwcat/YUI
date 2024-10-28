/// @description
function YuiDynamicElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "dynamic",
		
		// the dynamic content to render
		content: undefined,
	}
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	content = yui_bind(props.content, resources, slot_values);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {};
	}
	
	// feather ignore once GM2017
	static getBoundValues = function YuiDynamicElement_getBoundValues(data, prev) {
		var content = yui_resolve_binding(self.content, data);
		
		// diff
		if prev
			&& content == prev.content
		{
			return true;
		}
		
		return {
			is_live: true,
			content: content,
		};
	}
	
	static getDynamicElement = function(content) {
		// TODO optional caching
		return yui_resolve_element(content, resources, slot_values);
	}
}
