/// @description here
function yui_unscramble_string(str, curve_pos, state) {
	
	state[$"order"] ??= yui_random_range_order(string_length(str));
	
	var result = "";
	var i = 0; repeat string_length(str) {
		result += curve_pos > random(1)
			? string_char_at(str, i + 1)
			: chr(random_range(32, 126))
		i++;
	}
	return result;
}

function yui_random_range_order(count) {
	var order = array_create_ext(count, function(i) { return i });
	array_shuffle(order);
	return order;
}