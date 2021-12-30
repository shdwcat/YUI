/// @description Acts like a switch statement for UI, choosing a renderer based on whether a key matches the switch value
function YuiSwitchRenderer(_props, _resources, _slot_values) : YuiBaseRenderer(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "switch",
		switch_on: undefined, // binding to the switch value
		cases: {}, // struct map of values to case renderers
		default_case: undefined, // renderer when no case matches the switch value
		strict: false,
	}
	
	props = init_props_old(_props);
	props.switch_on = yui_bind(props.switch_on, resources, slot_values);
	
	// init case renderers
	case_renderers = snap_deep_copy(props.cases);
	//var case_keys = snap_struct_get_names(props.cases);
	//var i = 0; repeat array_length(case_keys) {
	//	var case_key = case_keys[i++];
	//	var yui_data = props.cases[$ case_key];
	//	var case_renderer = yui_resolve_renderer(yui_data, resources, slot_values);
		
	//	case_renderers[$ case_key] = case_renderer;
	//}
	
	if props.default_case != undefined {
		default_renderer = yui_resolve_renderer(props.default_case, resources, slot_values);
	}
	else {
		default_renderer = undefined;
	}
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			default_renderer: default_renderer,
			case_renderers: case_renderers,
		};
	}
	
	static getBoundValues = function(data, prev) {		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;		
		
		var switch_value = yui_resolve_binding(props.switch_on, data);
		
		// diff
		if prev
			&& switch_value == prev.switch_value
		{
			return true;
		}
		
		return {
			is_live: true,
			switch_value: switch_value,
		}
	}
	
	static getCaseElement = function(case_key) {
		var element = case_renderers[$ case_key];
		
		// make sure the case props are resolved to an element
		if element != undefined {
			
			// resolve the case props to renderers as needed (and store on the map for future use)
			if instanceof(element) == "struct" {
				element = yui_resolve_renderer(element, resources, slot_values);
				case_renderers[$ case_key] = element;
			}
		}
		else if default_renderer {
			element = default_renderer;
		}
		else if props.strict {
			throw yui_error("Could not find element for case:", case_key);
		}
		
		return element;
	}
}