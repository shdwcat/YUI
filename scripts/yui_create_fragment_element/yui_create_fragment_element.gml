/// @description creates a element from the provided fragment element props and definition
function yui_create_fragment_element(fragment_element_props, fragment_definition, resources, slot_values) {
	
	var content = snap_deep_copy(fragment_definition[$ "content"]);
	
	// store the original type name for reflection purposes
	content.element_type = fragment_element_props.type;
	
	
	// copy property overrides from element props to definition content
	// (allows things like canvas placement etc)
	var input_keys = variable_struct_get_names(fragment_element_props);
	var i = 0; repeat array_length(input_keys) {
		var input_key = input_keys[i++];
				
		if input_key == "type" {
			continue;
		}
		
		content[$ input_key] = fragment_element_props[$ input_key];		
	}
	
	var element = yui_resolve_element(content, resources, slot_values);
	
	return element;
}