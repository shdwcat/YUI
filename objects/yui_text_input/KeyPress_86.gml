/// @description Paste

if focused && keyboard_check(vk_control) && clipboard_has_text() {
	input_string_set(clipboard_get_text());
	after_caret = "";
}




