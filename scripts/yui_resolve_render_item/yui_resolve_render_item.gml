/// @description get the render item object index for the provided element type
function yui_resolve_render_item(type, element_props) {
	switch type {
		case "panel": return yui_panel;
		case "text": return yui_text;
		case "image": return yui_image;
		case "line": return yui_line;
		case "border": return yui_border;
		case "popup": return yui_popup;
		case "button":
			if element_props.popup {
				return yui_popup_button;
			}
			else {
				return yui_button;
			}
		case "switch": return yui_switch;
		case "data_template": return yui_data_template;
		default: return undefined;
	}
}