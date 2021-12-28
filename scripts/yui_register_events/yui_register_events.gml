/// @description registers events on a yui_cursor_item
function yui_register_events(events) {
	if events.on_mouse_down {
		left_pressed = function() {
			yui_handle_event(events.on_mouse_down, data_context);
		}
	}
}