/// @description here
function YuiTemplateDefinition(name, template_props, resources) constructor {
	type = "template";
	
	self.name = name;
	self.props = template_props; // for debugging
	self.resources = resources;
	
	trace = template_props[$"trace"];
	
	content = template_props[$"content"] ?? template_props[$"template"];
	if content == undefined
		throw yui_error("template definition must define 'content' property");
	
	content_type = content.type;
	content_events = content[$"events"];
	content_template = yui_get_or_init_template_def(resources, content_type);
	
	// TODO: convert back to regular map?
	slot_definitions = new YuiChainedMap(/* no parent*/,  template_props[$"slots"]);
	
	events = template_props[$"events"];

	static createElement = function(
		element_props,
		outer_slot_values,
		parent_element,
		outer_template_content = undefined) {
		
		// apply slot definitions from this template to the outer slot values
		var slot_values = applySlotValues(element_props, outer_slot_values, outer_template_content);
		
		// copy the raw element props so we can update the type to pass to the next level
		element_props = yui_shallow_copy(element_props);
		
		// set the type to the content type so that we don't recur back into this function
		element_props.type = content.type;
		
		// merge the template content
		// TODO: do this in construction?
		var template_def = outer_template_content
			? yui_apply_props(outer_template_content, content)
			: content;
		
		// NOTE: this is needed to get template styles in yui_apply_element_props
		element_props[$"template_type"] = name;
		element_props[$"template_def"] = template_def;
		
		// resolve template events
		if events
			resolveEvents(element_props, resources, slot_values);
			
		// merge content events with events from element props and outer template content
		var outer_events = outer_template_content ? outer_template_content[$"events"] : undefined;
		if outer_events || content_events {
			// TODO: currently events will override on collision, could merge handlers into array of handlers?
			element_props.events = yui_apply_props(element_props[$"events"], outer_events, content_events);
		}
		
		if content_template {
			var element = content_template.createElement(element_props, slot_values, parent_element, content);
		}
		else {
			// NOTE: have to do this in the scope of the parent element because
			// yui_resolve_element makes assumptions about what scope it's called in
			var template_slot_values = slot_values;
			with parent_element {
				var element = yui_resolve_element(element_props, resources, template_slot_values);
			}
		}
		
		// track which template created the element
		element.__template = self;
		
		return element;
	}
	
	static applySlotValues = function(element_props, outer_slot_values, outer_template_content = {}) {
		
		var instance_theme_name = element_props[$ "theme"];
		var theme = instance_theme_name != undefined
			? yui_resolve_theme(instance_theme_name)
			: outer_slot_values.get("theme");
		
		// NOTE: need to pull this in to apply theme props to slot values,
		// even though the values get folded into normal props later on
		var template_theme = theme.elements[$ name] ?? {};
		
		// create a new slot map (inheriting from the outer slots if any)
		var slot_values = new YuiChainedMap(outer_slot_values);
	
		// initialize the slot values by deep copying either the value from the theme or the slot definitions
		var slot_keys = slot_definitions.getKeys();
		var i = 0; repeat array_length(slot_keys) {
			var slot_key = slot_keys[i++];
			
			// the slot value is going to be either:
			// * the value from the element props, bound
			// * the value from the outer template content, bound
			// * the value from the theme, deep-copied
			// * the default value from our slot definitions, deep-copied
			
			var slot_value =
				((yui_bind(element_props[$ slot_key], resources, outer_slot_values, /*bind_arrays*/ true)
				?? yui_bind(outer_template_content[$ slot_key], resources, outer_slot_values, /*bind_arrays*/ true))
				?? yui_deep_copy(template_theme[$ slot_key]))
				?? yui_deep_copy(slot_definitions.get(slot_key));
				
			slot_values.set(slot_key, slot_value);
		}
	
		return slot_values;
	}
	
	static resolveEvents = function(element_props, outer_resources, slot_values) {
		
		// bind the handlers for the events defined in the template
		var resolved_events = {};
		var keys = variable_struct_get_names(events);
		var event_count = array_length(keys);
		var i = 0; repeat event_count {
			var key = keys[i];
			var handler = events[$ key];
			resolved_events[$ key] = yui_bind_handler(handler, outer_resources, slot_values);
		}
	
		// merge the events defined for the template with the events from element props
		if variable_struct_exists(element_props, "events") {
			// if the element has events, merge the definitions on top
			var i = 0; repeat event_count {
				var key = keys[i];
				if element_props.events[$ key] {
					yui_warning("overwriting event:", key);
				}
				element_props.events[$ key] = resolved_events[$ key];
			}
		}
		else {
			// if the element did not have events, just set the resolved events
			element_props.events = resolved_events;
		}
	}
}

function yui_get_or_init_template_def(resources, template_type) {

	var template_definition = resources[$ template_type];
	
	if template_definition == undefined || template_definition[$ "type"] != "template"
		return undefined
					
	// get or create the template definition
	var template_instance_type = instanceof(template_definition);
	if template_instance_type == "struct" {
		template_definition = new YuiTemplateDefinition(template_type, template_definition, resources);
						
		// update the resource entry so that we don't have to recreate it each time
		resources[$ template_type] = template_definition;
	}
	else if template_instance_type != "YuiTemplateDefinition" {
		throw yui_error("Unexpected template type:", template_type);
	}
			
	return template_definition;
}