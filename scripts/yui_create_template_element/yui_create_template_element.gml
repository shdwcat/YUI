/// @description creates the root element for a template instance
function yui_create_template_element(instance_props, template_definition, resources, outer_slot_values) {
				
	// defines what input slots the template supports
	var slot_definitions = template_definition[$ "slots"];
	
	// the props for the element we will create
	// need to copy the definition since we'll be updating the values
	// with the customized props from the instance_props
	var template_element_props = snap_deep_copy(template_definition.template);
	
	// if we're evaluating recursive templates, we need to consider the outer template 
	// as a source of slot values (e.g. context_menu overriding menu slot values)
	var outer_template = instance_props[$ "template_def"]
	
	// we also need to merge the top level props
	if outer_template != undefined {
		var type = template_element_props.type;
		template_element_props = yui_apply_props(outer_template, template_element_props);
		template_element_props.type = type;
	}
	
	// resolve the updated slot values that get passed to the template element
	var slot_values = yui_apply_slot_definitions(
		slot_definitions, // the slot definitions for this template
		instance_props, // the props for this instance of the template
		outer_template,
		outer_slot_values, // values coming in from the outer template
		resources);
	
	// store the original .yui type name for reflection purposes
	instance_props.yui_type = instance_props.type;
	
	// track the fragment type and definition to apply to props
	// NOTE: this may be recursive so we need to merge a new template definition with an existing one
	instance_props.template_type = instance_props.type;
	instance_props.template_def = template_element_props;
	instance_props.slot_defs = slot_definitions;
	
	// set the type to the definition root type to prevent recursion
	instance_props.type = template_element_props.type;
		
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
		if variable_struct_exists(instance_props, "events") {
			// if the element has events, merge the definitions on top
			var i = 0; repeat event_count {
				var key = keys[i];
				if instance_props.events[$ key] {
					yui_warning("overwriting event:", key);
				}
				instance_props.events[$ key] = event_definitions[$ key];
			}
		}
		else if event_definitions {
			// if the element did not have events, just set the defined events
			instance_props.events = event_definitions;
		}
	}
	
	var element_constructor = YuiGlobals.element_map[$ instance_props.type];
	if element_constructor != undefined {
		var template_element = new element_constructor(instance_props, resources, slot_values);
		return template_element;
	}
	else {
		return yui_resolve_element(instance_props, resources, slot_values);
	}
}