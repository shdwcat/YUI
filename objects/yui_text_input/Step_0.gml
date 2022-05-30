/// @description input_string tick

if focused {
	input_string_tick();
	
	var current = input_string_get();
	
	if (current != live_text) {
		live_text = current;
		yui_log("live_text: " + live_text);
	
		// override the bound text of the yui_text item
		content_item.override_text = live_text;
	
		// regen the text surface;
		content_item.buildTextSurface();
	}
}

