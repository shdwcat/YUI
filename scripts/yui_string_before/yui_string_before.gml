// get the portion of a string before some other string
// e.g. string_before("player: hello", ":") returns "player"
function yui_string_before(source, substring){
	var pos = string_pos(substring, source);
	return string_copy(source, 1, pos - 1);
}