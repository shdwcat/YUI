/// @description here
function yui_is_command(command) {
	var type = instanceof(command);
	return type == "YuiCommand" || type == "YuiMethodCommand";
}