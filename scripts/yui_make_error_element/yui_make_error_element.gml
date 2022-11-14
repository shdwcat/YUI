/// @description
function yui_make_error_element(error_message, resources, slot_values) {
	var props = {
		type: "button",
		yui_type: "button",
		id: "error",
		tooltip: error_message,
		border_color: "red",
		background: "#660000",
		padding: 5,
		size: { max_w: 210 },
		content: "Error!\n" + error_message,
	};
	var element = new YuiButtonElement(props, resources, slot_values);
	return element;
}