/// @description here
function yui_reveal_string(str, old_str, curve_pos) {
	var length = curve_pos * string_length(str);
	var result = string_copy(str, 1, length);
	return result;
}