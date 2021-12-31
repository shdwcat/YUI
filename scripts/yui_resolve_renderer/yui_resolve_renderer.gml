function yui_resolve_renderer(yui_data, resources, slot_values, parent_id = undefined) {
	if yui_data == undefined return undefined;

	// convert raw string elements to text data
	if is_string(yui_data) {
		if yui_is_binding_expr(yui_data) {
			yui_data = yui_bind(yui_data, resources, slot_values);
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
		
	if yui_data[$ "id"] == undefined {
		if parent_id == undefined && variable_struct_exists(self, "props") {
			parent_id = props.id;
		}
		
		// if it doesn't have an explicit ID, set it to the render tree path via the parent
		yui_data.id = (parent_id ?? "unknown parent") + "." + yui_data.type;
	}
	
	// store the real type name for reflection purposes
	if yui_data[$ "_type"] == undefined {
		yui_data._type = yui_data.type;
	}
	
	var renderer_constructor = YuiGlobals.renderer_map[? yui_data.type];	
	var renderer;
		
	if is_undefined(renderer_constructor) {
		// check for a template or fragment resource
		var element_definition = resources[$ yui_data.type];
			
		if !is_undefined(element_definition) {
			var element_type = element_definition[$ "type"]
			if element_type == "template" {
				renderer = yui_create_template_renderer(yui_data, element_definition, resources, slot_values);
			}
			else if element_type == "fragment" {
				renderer = yui_create_fragment_renderer(yui_data, element_definition, resources, slot_values);
			}
			else {
				throw new yui_string_concat("Unknown element resource type: ", element_type);
			}
		}
		else {
			throw yui_string_concat("could not find Renderer or Template for:", yui_data.type);
		}
	}
	else {
		renderer = new renderer_constructor(yui_data, resources, slot_values);
	}
	
	return renderer;
}