// get the portion of a string after some other string
// e.g. string_after("player: hello", ":") returns " hello"
function yui_string_after(source, substring){
	var pos = string_pos(substring, source);
	return string_copy(source, pos + string_length(substring), string_length(source) - pos);
}