/// @description creates the root element for a template instance
function yui_create_template_element(instance_props, template_definition, resources, parent_slot_values) {
				
	// defines what input slots the template supports
	var slot_definitions = template_definition[$ "slots"] ?? {};
	
	// the props for the element we will create
	// need to copy the definition since we'll be updating the values
	// with the customized props from the instance_props
	var template_element_props = snap_deep_copy(template_definition.template);
	
	// store the original .yui type name for reflection purposes
	template_element_props.yui_type = instance_props.type;
		
	// TODO: handle collision where both define data_source
	var instance_data_source = instance_props[$ "data_source"];
	if instance_data_source != undefined {
		// is this even needed?
		template_element_props.data_source = instance_data_source;
	}
	
	// resolve the updated slot values that get passed to the template element
	var slot_values = yui_apply_slot_definitions(
		slot_definitions, // the slot definitions for this template
		parent_slot_values, // values coming in from the parent
		instance_props, // the props for this instance of the template
		template_element_props,
		resources);
		
	// handle events defined on the template
	var event_definitions = template_definition[$ "events"];
	if event_definitions {
		
		// resolve the handlers for the events defined in the template to commands
		var keys = variable_struct_get_names(event_definitions);
		var event_count = array_length(keys);
		var i = 0; repeat event_count {
			var key = keys[i];
			var handler = event_definitions[$ key];
			event_definitions[$ key] = yui_bind_handler(handler, resources, slot_values);
		}
	
		// merge the events defined for the template with the events of the template's root_element
		if variable_struct_exists(template_element_props, "events") {
			// if the element has events, merge the definitions on top
			var i = 0; repeat event_count {
				var key = keys[i];
				if template_element_props.events[$ key] {
					yui_warning("overwriting event:", key);
				}
				template_element_props.events[$ key] = event_definitions[$ key];
			}
		}
		else if event_definitions {
			// if the element did not have events, just set the defined events
			template_element_props.events = event_definitions;
		}
	}
	
	var template_element = yui_resolve_element(template_element_props, resources, slot_values);
	return template_element;
}