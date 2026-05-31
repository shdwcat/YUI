/// @description return true if CleanShapes is included in the project
function yui_check_cleanshapes() {
	var script = asset_get_index("__CleanSystem");
	return script != -1;
}