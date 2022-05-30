/// @description 

// Inherit the parent event
event_inherited();

// track the current live text so we can determine when to update the inner yui_text element
live_text = undefined;

border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	max_chars = layout_props.max_chars;
	highlight_color = layout_props.highlight_color;
}

left_click = function() {
	if !focused {
		YuiCursorManager.setFocus(id);
	}
}

on_submit = function() {
	// invoke on_text_changed?
	yui_log("submitted: " + input_string_get());
}

on_got_focus = function() {
	// need to tick once so that the value we set doesn't get stomped
	input_string_tick();
	
	input_string_trigger_set(on_submit);
	
	live_text = content_item.bound_values.text;
	input_string_set(live_text);
}

on_lost_focus = function() {
	input_string_submit();
	input_string_set();
	content_item.override_text = undefined;
	live_text = undefined;
}
