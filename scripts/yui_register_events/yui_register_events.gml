/// @description registers events on a yui_cursor_item
function yui_register_events(events) {
	if events.on_mouse_down != undefined {
		left_pressed = function() {
			var source = self;
			var args = {
				source: source,
				button: "left",
			};
			yui_call_handler(events.on_mouse_down, [args], data_context);
		}
	}
	if events.on_mouse_up != undefined {
		left_click = function() {
			var source = self;
			var args = {
				source: source,
				button: "left",
			};
			yui_call_handler(events.on_mouse_up, [args], data_context);
		}
	}
	
	// TODO hook up other mouse buttons
	
	if events.on_mouse_wheel_up != undefined {
		on_mouse_wheel_up = function() {
			var source = self;
			var args = {
				source: source,
			};
			yui_call_handler(events.on_mouse_wheel_up, [args], data_context);
		}
	}
	
	if events.on_mouse_wheel_down != undefined {
		on_mouse_wheel_down = function() {
			var source = self;
			var args = {
				source: source,
			};
			yui_call_handler(events.on_mouse_wheel_down, [args], data_context);
		}
	}
}