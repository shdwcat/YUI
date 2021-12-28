/// @description creates a renderer from the provided fragment element and definition
function yui_create_fragment_renderer(fragment_element, fragment_definition, resources, slot_values) {
	
	var content = snap_deep_copy(fragment_definition[$ "content"]);
	
	// store the original type name for reflection purposes
	content._type = fragment_element.type;
	
	
	// copy property overrides from element to definition content
	// (allows things like canvas placement etc)
	var input_keys = variable_struct_get_names(fragment_element);
	var i = 0; repeat array_length(input_keys) {
		var input_key = input_keys[i++];
				
		if input_key == "type" {
			continue;
		}
		
		content[$ input_key] = fragment_element[$ input_key];		
	}
	
	var renderer = yui_resolve_renderer(content, resources, slot_values);
	
	return renderer;
}