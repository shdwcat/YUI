/// @description here
function yui_pop_in_string(str, curve_pos) {
	var result = "";
	var i = 0; repeat string_length(str) {
		result += curve_pos > random(1)
			? string_char_at(str, i + 1)
			: " "
		i++;
	}
	return result;
}