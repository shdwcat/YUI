/// @description Sets up Input lib compatibility
function __yui_init_input_lib() {
	if YUI_INPUT_LIB_QUICK_SETUP {
		var pageup_binding = input_binding_key(vk_pageup);
		var pagedown_binding = input_binding_key(vk_pagedown);
			
		// bind kb page up/down to focus scope scrolling
		
		input_binding_set(
			YUI_INPUT_VERB_PAD_SCROLL_UP,
			pageup_binding,
			, // default player
			, // alt binding
			"keyboard_and_mouse"); // profile
		
		input_binding_set(
			YUI_INPUT_VERB_PAD_SCROLL_DOWN,
			pagedown_binding,
			, // default player
			, // alt binding
			"keyboard_and_mouse"); // profile
	}
}