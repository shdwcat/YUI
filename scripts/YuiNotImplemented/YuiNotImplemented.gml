/// @description placeholder for not-yet-implemented types
function YuiNotImplemented(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "edit this",
		padding: 0,
	}
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			// values that will not change based on bindings
		};
	}
	
	static getBoundValues = function(data, prev) {
		return {
			// resolved bound values
		}
	}
}