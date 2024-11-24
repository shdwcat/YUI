/// @description log the message
function yui_log(message = "") {
	
	//if argument_count == 0 return;

	//var message = argument[0];


	//var i = 1; repeat argument_count - 1 {
	//	message += " ";
	
	//	var token = argument[i]
	//	if is_string(token)
	//		message += token;
	//	else
	//		message += string(token);
	
	//	i++;
	//}

	show_debug_message(message);
}

function yui_log_to_datafile(filename, message = "") {
	if GM_build_type == "exe" return
	
	var _f = file_text_open_append(YUI_LOCAL_PROJECT_DATA_FOLDER + filename);
	if (_f == -1) {
		throw yui_error($"Unable to open data file '{filename}' for append");
	}
	
    file_text_write_string(_f, message);
	file_text_writeln(_f);
	
    file_text_close(_f);
}

function yui_log_asset_use(name, type, source) {
	if GM_build_type == "exe" return
	
	static used_assets = {}
	
	if used_assets[$ name] == undefined {
		used_assets[$ name] = true;
		yui_log_to_datafile(YUI_ASSET_USE_CSV, $"{name}, {type}, \"{source}\"");
	}
}
