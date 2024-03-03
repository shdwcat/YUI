/// @desc  get the layout constructor for the provided layout type
/// @param {string} layout_type
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
		case "radial":
			return YuiRadialLayout;
		default:
			yui_error("unknown layout type:", layout_type);
			return undefined;
	}

}