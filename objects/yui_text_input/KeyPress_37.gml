/// @description Caret Left

if focused {
	var str = input_string_get();
	var len = string_length(str);
	if len > 0 {
		after_caret = string_copy(str, len, len) + after_caret;
		var before_caret = string_copy(str, 1, len - 1);
		input_string_set(before_caret);
	}
}
