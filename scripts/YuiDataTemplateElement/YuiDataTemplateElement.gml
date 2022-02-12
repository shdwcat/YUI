/// @description renders a YUI Data Template
function YuiDataTemplateElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "data_template",
		data_type: undefined,
		
		resource_group: undefined, // this is the group of resources that contains the data templates
		resource_key: undefined, // this is the key to look up within the group (usually bound)
		
		strict: false,
	}
	
	props = yui_init_props(_props);
	props.resource_key = yui_bind(props.resource_key, resources, slot_values);
	
	// this is unique pet data_template element!
	category_map = yui_resolve_resource_category_map(props.resource_group, _resources)
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return;
	}
	
	static getBoundValues = function(data, prev) {
		var resource_key = yui_resolve_binding(props.resource_key, data);
		
		// diff
		if prev
			&& resource_key == prev.resource_key
		{
			return true;
		}
		
		return {
			is_live: true,
			resource_key: resource_key,
		};
	}
	
	static getTemplateElement = function(resource_key) {
		var template_element = category_map[$ resource_key];
		
		// if we found a template definition, make sure it's resolved to an element
		if template_element != undefined {
			
			// resolve the template props to elements as needed (and store on the map for future use)
			if instanceof(template_element) == "struct" {
				template_element = yui_resolve_element(template_element, resources, slot_values);
				category_map[$ resource_key] = template_element;
			}
		}
		else if props.strict {
			throw "Could not find resource template from group '" +
				props.resource_group + "' with key '" + resource_key + "'";
		}
		
		return template_element;
	}
}