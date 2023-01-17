/// @description
function yui_make_error_element(error, resources, slot_values) {
	
	if is_string(error) {
		var tooltip = error;
		var message = error;
	}
	else if is_struct(error) {
		var is_gml_error = instanceof(error) == "YYGMLException";
		if is_gml_error
			var message = "GML ERROR: " + error.message;
		else
			var message = error.message;
		
		var tooltip = error.stacktrace;
	}
	else {
		throw yui_error("Unexpected error value for yui_make_error_element");
	}
	
	var props = {
		type: "button",
		yui_type: "button",
		id: "error",
		tooltip: tooltip,
		border_color: "red",
		background: "#660000",
		padding: 5,
		size: { max_w: 210 },
		content: message,
		data_source: error,
		on_click: "e => clipboard_set_text(@)",
	};
	
	var element = new YuiButtonElement(props, resources, slot_values);
	return element;
}