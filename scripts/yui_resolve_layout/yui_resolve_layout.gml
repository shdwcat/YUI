/// @description get the layout constructor for the provided layout type
function yui_resolve_layout(layout_type) {
	
	switch layout_type {
		case "vertical":
			return YuiVerticalLayout;
		case "horizontal":
			return YuiHorizontalLayout;
		case "canvas":
			return YuiCanvasLayout;
		case "grid":
			return YuiGridLayout;
		default:
			yui_error("unknown layout type:", layout_type);
			return undefined;
	}

}