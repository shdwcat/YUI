/// @description here
function YuiTemplateDef(name, template_props, resources) constructor {
	type = "template";
	
	self.name = name;
	self.props = template_props; // for debugging
	self.resources = resources;
	
	trace = template_props[$"trace"];
	
	content = template_props[$"content"] ?? template_props[$"template"];
	if content == undefined
		throw yui_error("template definition must define 'content' property");
	
	content_type = content.type;
	content_template = yui_get_or_init_template_def(resources, content_type);
	
	var slots = template_props[$"slots"];

	// if the content root is a template, extend its slots with our slots
	if content_template {
		slot_definitions = content_template.slot_definitions.extendWith(slots);
	}
	// otherwise just use our slots as the slot definitions
	else {
		slot_definitions = new YuiChainedMap(/* no parent*/, slots);
	}
	
	events = template_props[$"events"];

	static createElement = function(element_props, outer_resources, outer_slot_values, parent_element) {
		
		// NOTE: we use the outer resources because the content_template constructor will need access to those
		
		// apply slot definitions from this template to the outer slot values
		var slot_values = applySlotValues(element_props, outer_slot_values);
		
		// merge the element props with the props from our template content
		var merged_element_props = yui_shallow_copy(element_props);//yui_apply_props(element_props, content)
		
		// set the type to the content type so that we don't recur back into this function
		merged_element_props.type = content.type;
		
		// NOTE: this is needed to get template styles in yui_apply_element_props
		merged_element_props[$"template_type"] ??= name;
		merged_element_props[$"template_def"] ??= content;
		
		if events
			resolveEvents(merged_element_props, outer_resources, slot_values);
		
		if content_template {
			var element = content_template.createElement(merged_element_props, outer_resources, slot_values, parent_element);
		}
		else {
			// NOTE: have to do this in the scope of the parent element because
			// yui_resolve_element makes assumptions about what will be executing it
			var template_slot_values = slot_values;
			with parent_element {
				var element = yui_resolve_element(merged_element_props, outer_resources, template_slot_values);
			}
		}
		
		// track which template created the element
		element.__template = self;
		
		
		return element;
	}
	
	static applySlotValues = function(element_props, outer_slot_values) {
		var instance_theme_name = element_props[$ "theme"];
		try {
		var theme = instance_theme_name != undefined
			? yui_resolve_theme(instance_theme_name)
			: outer_slot_values.get("theme");
		}
		catch (error) {
			throw error
		}
		
		var template_theme = theme.elements[$ element_props.yui_type] ?? {};
		
		// create a new slot map (inheriting from the outer slots if any)
		var slot_values = new YuiChainedMap(outer_slot_values);
	
		// initialize the slot values by deep copying either the value from the theme or the slot definitions
		var slot_keys = slot_definitions.getKeys();
		var i = 0; repeat array_length(slot_keys) {
			var slot_key = slot_keys[i++];
			
			// the slot value is going to be either:
			// * the value from the element props, bound
			// * the value from the theme, deep-copied
			// * the default value from our slot definitions, deep-copied
			
			var slot_value =
				(yui_bind(element_props[$ slot_key], resources, outer_slot_values, /*bind_arrays*/ true)
				?? yui_deep_copy(getThemeValue(template_theme, slot_key)))
				?? yui_deep_copy(slot_definitions.get(slot_key));
				
			slot_values.set(slot_key, slot_value);
		}
		
		if name == "scrollbox"
			DEBUG_BREAK_YUI
	
		return slot_values;
	}
	
	static getThemeValue = function(theme, key) {
		return theme[$key];
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
	
		// merge the events defined for the template with the events of our content element
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
		template_definition = new YuiTemplateDef(template_type, template_definition, resources);
						
		// update the resource entry so that we don't have to recreate it each time
		resources[$ template_type] = template_definition;
	}
	else if template_instance_type != "YuiTemplateDef" {
		throw yui_error("Unexpected template type:", template_type);
	}
			
	return template_definition;
}