/// @description returns the slot_inputs based on the slot definitions and template props
function yui_init_slot_inputs(slots, template_input_props, template_renderer_props) {
	
	// copy the definiton to the slot_inputs since these are the default inputs
	var slot_inputs = snap_deep_copy(slots);
	
	// loop through the values in template_input_props and overlay them on the slot_inputs
	var input_keys = variable_struct_get_names(template_input_props);
	var i = 0; repeat array_length(input_keys) {
		var input_key = input_keys[i++];
		
		// NOTE: maybe slot inputs should go in a .slot_inputs property to avoid this?
		// or maybe prefix all of these with $ and anything with $ gets skipped
		if input_key == "type"
		
		// these have to do with data templates
		// TODO: should change the data template to define the element in a subprop, to avoid this
		|| input_key == "resource_group"
		|| input_key == "resource_key"
		
		|| input_key == "item_key" {
			continue;
		}
				
		var slot_exists = variable_struct_exists(slots, input_key);
		if slot_exists {
			// if slot exists, copy value into slot
			slot_inputs[$ input_key] = template_input_props[$ input_key];
		}
		else {
			// otherwise, just copy it to the template_renderer props
			template_renderer_props[$ input_key] = template_input_props[$ input_key];
		}
	}
	
	return slot_inputs;
}