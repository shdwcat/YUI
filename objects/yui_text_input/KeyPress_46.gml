/// @description Delete

if focused {
	after_caret = string_copy(after_caret, 2, string_length(after_caret) - 1);
	update = true;
}

