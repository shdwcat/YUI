/// @description registers events on a yui_cursor_item
function yui_register_events(events) {
	if events.on_mouse_down {
		left_pressed = function() {
			var source = self;
			var args = {
				source: source,
				button: "left",
			};
			yui_call_handler(events.on_mouse_down, [args], data_context);
		}
	}
}