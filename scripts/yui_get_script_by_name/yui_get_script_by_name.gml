function yui_get_script_by_name(script_name) {
	if asset_get_type(script_name) != asset_script {
		throw script_name + " is not the name of a script resource";
	}
	var script = asset_get_index(script_name);
	return script;	
}