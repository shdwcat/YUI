/// @desc applies slot_definitions to template_element props, and returns the slot_values for the template instance
function yui_apply_slot_definitions(
	slot_definitions,
	template_instance_props,
	parent_template,
	parent_slot_values,
	resources
	) {
	
	// ensure we have a slot definitions struct
	slot_definitions ??= {};
	
	var instance_theme_name = template_instance_props[$ "theme"];
	var theme = instance_theme_name != undefined
		? yui_resolve_theme(instance_theme_name)
		: parent_slot_values[$ "theme"];
		
	var template_theme = theme.elements[$ template_instance_props.yui_type] ?? {};
	
	// initialize the slot values by deep copying either the value from the theme or the slot definitions
	var slot_values = {};
	var slot_keys = variable_struct_get_names(slot_definitions);
	var i = 0; repeat array_length(slot_keys) {
		var slot_key = slot_keys[i++];
		slot_values[$ slot_key] = snap_deep_copy(template_theme[$ slot_key] ?? slot_definitions[$ slot_key]);
	}
	
	// loop through the values in template_instance_props and overlay them on the slot_values
	var input_keys = variable_struct_get_names(template_instance_props);
	var i = 0; repeat array_length(input_keys) {
		var input_key = input_keys[i++];
		
		if input_key == "type"
		
		// these have to do with data templates
		// TODO: should change the data template to define the element in a subprop, to avoid this
		|| input_key == "resource_group"
		|| input_key == "resource_key"
		
		|| input_key == "item_key" {
			continue;
		}
				
		var slot_exists = variable_struct_exists(slot_definitions, input_key);
		if slot_exists {
			// if slot exists, bind it and copy value into slot
			var slot_value = template_instance_props[$ input_key];
			
			// bind the value (and bind inner arrays to deal with event handler array values)
			// TODO: move all handlers slots to 'events' so that they get bound as handlers
			// and then copy over to slots?
			var bound_value = yui_bind(slot_value, resources, parent_slot_values, true);
			
			slot_values[$ input_key] = bound_value;
		}
		// should this get deleted from the instance props?
		// if so then we'd have to do background: $background if we wanted a background *slot* and apply to template root
	}
	
	// loop through the values in parent template and overlay them on the slot_values
	if parent_template != undefined {
		var input_keys = variable_struct_get_names(parent_template);
		var i = 0; repeat array_length(input_keys) {
			var input_key = input_keys[i++];
		
			if input_key == "type"
		
			// these have to do with data templates
			// TODO: should change the data template to define the element in a subprop, to avoid this
			|| input_key == "resource_group"
			|| input_key == "resource_key"
		
			|| input_key == "item_key" {
				continue;
			}
				
			var slot_exists = variable_struct_exists(slot_definitions, input_key);
			if slot_exists {
				// if slot exists, bind it and copy value into slot
				var slot_value = parent_template[$ input_key];
			
				// bind the value (and bind inner arrays to deal with event handler array values)
				// TODO: move all handlers slots to 'events' so that they get bound as handlers
				// and then copy over to slots?
				var bound_value = yui_bind(slot_value, resources, parent_slot_values, true);
			
				slot_values[$ input_key] = bound_value;
			}
			// should this get deleted from the instance props?
			// if so then we'd have to do background: $background if we wanted a background *slot* and apply to template root
		}
	}
	
	// now copy the parent slot values into the output slot values
	// this way the instance props for an inner template can use $slot binding
	// to access the slot values defined on an outer template
	// (AKA using template instances inside the template definition of another template such as a checkbox in a menu)
	if parent_slot_values {
		var parent_slot_names = variable_struct_get_names(parent_slot_values);
		var i = 0; repeat array_length(parent_slot_names) {
			var parent_slot_name = parent_slot_names[i++];
			
			var slot_overlaps = variable_struct_exists(slot_values, parent_slot_name);
			if slot_overlaps {
				// if the child has the same slot as the parent, leave the child slot alone
				// an example where this can happen is a recursive template (see menu.yui)
			}
			else {
				slot_values[$ parent_slot_name] = parent_slot_values[$ parent_slot_name];
			}
		}
	}
	
	return slot_values;
}