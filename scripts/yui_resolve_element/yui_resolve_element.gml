function yui_resolve_element(yui_data, resources, slot_values, parent_id = undefined) {
	
	static element_map = {
		panel: YuiPanelElement,
		text: YuiTextElement,
		image: YuiImageElement,
		line: YuiLineElement,
		border: YuiBorderElement,
		button: YuiButtonElement,
		popup: YuiPopupElement,
		"switch": YuiSwitchElement,
		data_template: YuiDataTemplateElement,
		viewport: YuiViewportElement,
		text_input: YuiTextInputElement,
	}
	
	if yui_data == undefined return undefined;

	// convert raw string elements to text data
	if is_string(yui_data) {
		if yui_is_binding_expr(yui_data) {
			var resolved_yui_data = yui_bind(yui_data, resources, slot_values);
			
			// if the result is not a binding, copy the resolved values to ensure we're not sharing state incorrectly
			if !yui_is_binding(resolved_yui_data) && (is_struct(resolved_yui_data) || is_array(resolved_yui_data)) {
				resolved_yui_data = snap_deep_copy(resolved_yui_data)
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
		slot_values = {
			theme: theme,
		}
	}
	
	if yui_data[$ "id"] == undefined {
		if parent_id == undefined && variable_struct_exists(self, "props") {
			parent_id = props.id;
		}
		
		// if it doesn't have an explicit ID, set it to the render tree path via the parent
		yui_data.id = (parent_id ?? "unknown parent") + "." + yui_data.type;
	}
	
	// store the .yui type name for reflection purposes
	if yui_data[$ "yui_type"] == undefined {
		yui_data.yui_type = yui_data.type;
	}
	
	var element_constructor = element_map[$ yui_data.type];	
	var element;
		
	if is_undefined(element_constructor) {
		// check for a template or fragment resource
		var element_definition = resources[$ yui_data.type];
			
		if !is_undefined(element_definition) {
			var element_type = element_definition[$ "type"]
			if element_type == "template" {
				element = yui_create_template_element(yui_data, element_definition, resources, slot_values);
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