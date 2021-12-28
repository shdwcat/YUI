/// @description get the layout constructor for the provided layout type
function yui_get_layout_constructor(layout_type) {
	
	switch layout_type {
		case "vertical":
			return YuiVerticalLayout2;
		case "horizontal":
			return YuiHorizontalLayout2;
		case "canvas":
			return YuiCanvasLayout2;
		case "grid":
			return YuiGridLayout2;
		default:
			yui_error("unknown layout type:", layout_type);
			return undefined;
	}

}