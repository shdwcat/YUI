/// @description Caret End

if focused {
	input_string_set(input_string_get() + after_caret);
	after_caret = "";
}


