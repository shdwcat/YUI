// TODO next major version - delete this

///// @description here
//function yui_load_interactions() {
//	var files = gumshoe(YUI_LOCAL_PROJECT_DATA_FOLDER + YUI_DATA_SUBFOLDER + "Interactions", "yui");
	
//	var map = {};
//	var i = 0; repeat array_length(files) {
//		var filename = files[i++];
//		var filetext = string_from_file(filename);
//		var snap = snap_from_yui(filetext, undefined, true);
		
//		// hack
//		var resources = {};
		
//		var makeFunc = undefined;
//		switch (snap.type) {
//			case "drag_and_drop":
//				makeFunc = YuiDragAndDrop;
//				break;
//			case "pan_camera":
//				makeFunc = YuiPanCamera;
//				break;
//			case "canvas_drag":
//			case "element_drag":
//				makeFunc = YuiElementDrag;
//				break;
//		}
		
//		map[$ snap.id] = new makeFunc(snap, resources);
//	}
	
//	return map;
//}