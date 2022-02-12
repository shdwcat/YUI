/// @description Acts like a switch statement for UI, choosing a element based on whether a key matches the switch value
function YuiSwitchElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "switch",
		switch_on: undefined, // binding to the switch value
		cases: {}, // struct map of values to case elements
		default_case: undefined, // element when no case matches the switch value
		strict: false,
	}
	
	props = yui_init_props(_props);
	props.switch_on = yui_bind(props.switch_on, resources, slot_values);
	
	// init case elements
	case_elements = snap_deep_copy(props.cases);
	
	if props.default_case != undefined {
		default_element = yui_resolve_element(props.default_case, resources, slot_values);
	}
	else {
		default_element = undefined;
	}
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			default_element: default_element,
			case_elements: case_elements,
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
		var element = case_elements[$ case_key];
		
		// make sure the case props are resolved to an element
		if element != undefined {
			
			// resolve the case props to elements as needed (and store on the map for future use)
			if instanceof(element) == "struct" {
				element = yui_resolve_element(element, resources, slot_values);
				case_elements[$ case_key] = element;
			}
		}
		else if default_element {
			element = default_element;
		}
		else if props.strict {
			throw yui_error("Could not find element for case:", case_key);
		}
		
		return element;
	}
}