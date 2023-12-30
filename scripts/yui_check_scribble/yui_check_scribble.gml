/// @description return true if Scribble is included in the project
function yui_check_scribble() {
	// check for scribble_typist since a project *could* randomly have a 'scribble' asset
	var script = asset_get_index("scribble_typist")
	return script != -1;
}