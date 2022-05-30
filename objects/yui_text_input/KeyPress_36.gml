/// @description Caret Home

if focused {
	after_caret = input_string_get() + after_caret;
	input_string_set();
}

