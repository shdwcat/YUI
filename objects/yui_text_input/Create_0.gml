/// @description 

// Inherit the parent event
event_inherited();

// whether to force an update to the yui_text element
update = false;

// track the current live text so we can determine when to update the inner yui_text element
live_text = undefined;
after_caret = "";
caret_color = c_white;
caret_x = undefined;
caret_y = undefined;
caret_h = undefined;

border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	max_chars = layout_props.max_chars;
	highlight_color = layout_props.highlight_color;
}

border_build = build;
build = function() {
	enabled = bound_values.enabled;
	focusable = bound_values.enabled;
	border_build();
}

border_arrange = arrange;
arrange = function(available_size, viewport_size) {
	var size = border_arrange(available_size, viewport_size);
	
	caret_y = content_item.draw_size.y;
	caret_h = content_item.draw_size.h;
	
	return size;
}

border_move = move;
move = function(xoffset, yoffset) {
	border_move(xoffset, yoffset);
	caret_x += xoffset;
	caret_y += yoffset;
}

left_click = function() {
	if focusable && !focused {
		YuiCursorManager.setFocus(id);
	}
}

on_submit = function() {
	var submit_text = input_string_get() + after_caret;
	if events.on_text_changed != undefined {
		yui_call_handler(events.on_text_changed, [submit_text], bound_values.data_source);
	}
	yui_log("submitted: " + submit_text);
}

on_got_focus = function() {
	update = false;
	input_string_trigger_set(on_submit);
}

on_lost_focus = function() {
	input_string_submit();
	input_string_set();
	if content_item && instance_exists(content_item) {
		content_item.override_text = undefined;
	}
	live_text = undefined;
	after_caret = "";
	original_text = undefined;
	update = false;
}



