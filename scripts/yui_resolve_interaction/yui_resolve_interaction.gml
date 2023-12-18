/// @description
function yui_resolve_interaction(snap) {
	// hack TODO real resources/import
	var resources = {};
	
	var make_func = undefined;
	switch (snap.type) {
		case "drag_and_drop":
			make_func = YuiDragAndDrop;
			break;
		case "pan_camera":
			make_func = YuiPanCamera;
			break;
		case "canvas_drag":
		case "element_drag":
			make_func = YuiElementDrag;
			break;
	}
	
	var result = new make_func(snap, resources);
	return result;
}

