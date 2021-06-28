/// @description here
function yui_load_interactions() {
	var files = gumshoe("Game_Data/UI/Interactions", "yaml");
	
	var map = {};
	var i = 0; repeat array_length(files) {
		var filename = files[i++];
		var filetext = string_from_file(filename);
		var snap = snap_from_yaml(filetext, undefined, true);
		
		// hack
		var resources = {};
		
		var makeFunc = undefined;
		switch (snap.type) {
			case "drag_and_drop":
				makeFunc = YuiDragAndDrop;
				break;
			case "pan_camera":
				makeFunc = YuiPanCamera;
				break;
		}
		
		map[$ snap.id] = new makeFunc(snap, resources);;
	}
	
	return map;
}