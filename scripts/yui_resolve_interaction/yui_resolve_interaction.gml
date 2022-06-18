/// @description
function yui_resolve_interaction(snap) {
	// hack TODO real resources/import
	var resources = {};
	
	var makeFunc = undefined;
	switch (snap.type) {
		case "drag_and_drop":
			makeFunc = YuiDragAndDrop;
			break;
		case "pan_camera":
			makeFunc = YuiPanCamera;
			break;
		case "canvas_drag":
		case "element_drag":
			makeFunc = YuiElementDrag;
			break;
	}
	
	var result = new makeFunc(snap, resources);
	return result;
}

