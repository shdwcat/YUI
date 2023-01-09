function yui_resolve_element(yui_data, resources, slot_values, parent_id = undefined) {
	
	static element_map = YuiGlobals.element_map;
	
	try {
		if yui_data == undefined return undefined;

		// convert raw string elements to text data
		if is_string(yui_data) {
			if yui_is_binding_expr(yui_data) {
				var resolved_yui_data = yui_bind(yui_data, resources, slot_values);
			
				// if the result is not a binding, copy the resolved values to ensure we're not sharing state incorrectly
				if !yui_is_binding(resolved_yui_data) && (is_struct(resolved_yui_data) || is_array(resolved_yui_data)) {
					resolved_yui_data = yui_deep_copy(resolved_yui_data)
				}
			
				// the result might be something like a slot or resource, or 'raw' element props
				// In any of those cases, this recursive call will resolve that value correctly.
				return yui_resolve_element(resolved_yui_data, resources, slot_values, parent_id);
			}
			yui_data = {
				type: "text",
				text: yui_data,
			};
		}
		else if yui_is_binding(yui_data) {
			// wrap a raw binding in a text element (assumes it's a text binding!)
			yui_data = {
				type: "text",
				text: yui_data,
			};
		}
	
		// if we don't have slots yet (because this is a root element)
		// then resolve the theme and use it as the initial slot values
		if slot_values == undefined {
			var theme = yui_resolve_theme(yui_data[$ "theme"]);
			slot_values = new YuiChainedMap(/* no parent */, {
				theme: theme,
			});
		}
	
		if yui_data[$ "id"] == undefined {
			if parent_id == undefined && variable_struct_exists(self, "props") {
				parent_id = self.props.id;
			}
		
			// if it doesn't have an explicit ID, set it to the render tree path via the parent
			yui_data.id = (parent_id ?? "unknown parent") + "." + yui_data.type;
		}
	
		// store the .yui type name for reflection purposes
		if yui_data[$ "yui_type"] == undefined {
			yui_data.yui_type = yui_data.type;
		}
	
		var element;
		var element_constructor = element_map[$ yui_data.type];

		// if this isn't a core element, check for a template or fragment resource
		if element_constructor == undefined {
			var element_definition = resources[$ yui_data.type];
			if element_definition != undefined {
				var element_type = element_definition[$ "type"]
				if element_type == "template" {
					
					// get or create the template definition
					var template_type = instanceof(element_definition);
					if template_type == "struct" {
						element_definition = new YuiTemplateDef(yui_data.type, element_definition, resources);
						
						// update the resource entry so that we don't have to recreate it each time
						resources[$yui_data.type] = element_definition;
					}
					else if template_type != "YuiTemplateDef" {
						throw yui_error("Unexpected template type:", template_type);
					}
					
					// create the element from the template_definition
					element = element_definition.createElement(yui_data, resources, slot_values, /*parent*/ self);
				}
				else if element_type == "fragment" {
					element = yui_create_fragment_element(yui_data, element_definition, resources, slot_values);
				}
				else {
					throw new yui_error("Unknown element resource type: ", element_type);
				}
			}
			else {
				throw yui_error("could not find Element or Template for:", yui_data.type);
			}
		}
		else {
			element = new element_constructor(yui_data, resources, slot_values);
		}
	
		return element;
	}
	catch (error) {
		var message = is_string(error) ? error : error.message;
		return yui_make_error_element(message, resources, slot_values);
	}
}