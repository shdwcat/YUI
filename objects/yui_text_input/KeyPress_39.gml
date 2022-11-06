/// @description Caret Right

if focused && after_caret != "" {
	
	var str = input_string_get() + string_char_at(after_caret, 1);
	input_string_set(str);
	
	var after_length = string_length(after_caret);
	after_caret = after_length > 1
		? string_copy(after_caret, 2, after_length - 1)
		: "";
}


