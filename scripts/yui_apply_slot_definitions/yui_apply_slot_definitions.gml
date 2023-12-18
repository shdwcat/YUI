// TODO next major version - delete this

///// @desc applies slot_definitions to template_element props, and returns the slot_values for the template instance
//function yui_apply_slot_definitions(
//	slot_definitions,
//	template_instance_props,
//	parent_template,
//	parent_slot_values,
//	resources
//	) {
	
//	var instance_theme_name = template_instance_props[$ "theme"];
//	var theme = instance_theme_name != undefined
//		? yui_resolve_theme(instance_theme_name)
//		: parent_slot_values.get("theme");
		
//	var template_theme = theme.elements[$ template_instance_props.yui_type] ?? {};
	
//	// create a new slot map (inheriting from the parent if any)
//	var slot_values = new YuiChainedMap(parent_slot_values);
	
//	// initialize the slot values by deep copying either the value from the theme or the slot definitions
//	var slot_keys = variable_struct_get_names(slot_definitions);
//	var i = 0; repeat array_length(slot_keys) {
//		var slot_key = slot_keys[i++];
//		var slot_value = template_theme[$ slot_key] ?? slot_definitions[$ slot_key];
//		slot_values.set(slot_key, yui_deep_copy(slot_value));
//	}
	
//	// loop through the values in template_instance_props and overlay them on the slot_values
//	var input_keys = variable_struct_get_names(template_instance_props);
//	var i = 0; repeat array_length(input_keys) {
//		var input_key = input_keys[i++];
		
//		if input_key == "type"
//		|| input_key == "yui_type"
		
//		// these have to do with data templates
//		// TODO: should change the data template to define the element in a subprop, to avoid this
//		|| input_key == "resource_group"
//		|| input_key == "resource_key"
		
//		|| input_key == "item_key" {
//			continue;
//		}
				
//		var slot_exists = variable_struct_exists(slot_definitions, input_key);
//		if slot_exists {
//			// if slot exists, bind it and copy value into slot
//			var slot_value = template_instance_props[$ input_key];
			
//			// bind the value (and bind inner arrays to deal with event handler array values)
//			// TODO: move all handlers slots to 'events' so that they get bound as handlers
//			// and then copy over to slots?
//			var bound_value = yui_bind(slot_value, resources, parent_slot_values, true);
			
//			slot_values.set(input_key, bound_value);
//		}
//	}
	
//	// loop through the values in parent template and overlay them on the slot_values
//	if parent_template != undefined {
//		var input_keys = variable_struct_get_names(parent_template);
//		var i = 0; repeat array_length(input_keys) {
//			var input_key = input_keys[i++];
		
//			if input_key == "type"
		
//			// these have to do with data templates
//			// TODO: should change the data template to define the element in a subprop, to avoid this
//			|| input_key == "resource_group"
//			|| input_key == "resource_key"
		
//			|| input_key == "item_key" {
//				continue;
//			}
				
//			var slot_exists = variable_struct_exists(slot_definitions, input_key);
//			if slot_exists {
//				// if slot exists, bind it and copy value into slot
//				var slot_value = parent_template[$ input_key];
			
//				// bind the value (and bind inner arrays to deal with event handler array values)
//				// TODO: move all handlers slots to 'events' so that they get bound as handlers
//				// and then copy over to slots?
//				var bound_value = yui_bind(slot_value, resources, parent_slot_values, true);
			
//				slot_values.set(input_key, bound_value);
//			}
//			// should this get deleted from the instance props?
//			// if so then we'd have to do background: $background if we wanted a background *slot* and apply to template root
//		}
//	}
	
//	return slot_values;
//}