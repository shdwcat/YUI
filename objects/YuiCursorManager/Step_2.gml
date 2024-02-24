/// @description

//if false var ref = __input_config_verbs;

// feather disable GM1044

if YUI_INPUT_LIB_ENABLED && is_navigation_active {
		
	if input_check_released(YUI_INPUT_VERB_ACCEPT) {
		activateFocused();
	}
	else {
		// first check kb/gamepad scrolling (default: page up / right stick)
		// add pressed and repeat to catch both initial and repeated inputs 
		// (which allows e.g. holding a direction to scroll through a list)
		var focus_up_down = input_check_opposing_pressed(YUI_INPUT_VERB_PAD_SCROLL_UP, YUI_INPUT_VERB_PAD_SCROLL_DOWN)
			+ input_check_opposing_repeat(YUI_INPUT_VERB_PAD_SCROLL_UP, YUI_INPUT_VERB_PAD_SCROLL_DOWN, , , 5, 15);
		var focus_left_right = input_check_opposing(YUI_INPUT_VERB_PAD_SCROLL_LEFT, YUI_INPUT_VERB_PAD_SCROLL_RIGHT)
			+ input_check_opposing_repeat(YUI_INPUT_VERB_PAD_SCROLL_LEFT, YUI_INPUT_VERB_PAD_SCROLL_RIGHT, , , 5, 15);
			
		if focus_up_down != 0 && focused_item != undefined && instance_exists(focused_item) {
			if focus_up_down < 0 && focused_item.on_mouse_wheel_up {
				// feather ignore once GM1021
				focused_item.on_mouse_wheel_up();
			}
			else if focused_item.on_mouse_wheel_down {
				// feather ignore once GM1021
				focused_item.on_mouse_wheel_down();
			}
		}
		else {
			// then kb/gamepad focus
			// focus only moves if we did *not* activate/scroll the previous focus this frame
			// (otherwise it would be nonsensical which thing was activated vs rendered as focused)
		
			// 4 directional support
			// FUTURE: diagonal support for gamepads?
		
			var left_right = 
				input_check_opposing_pressed(YUI_INPUT_VERB_LEFT, YUI_INPUT_VERB_RIGHT)
				+ input_check_opposing_repeat(YUI_INPUT_VERB_LEFT, YUI_INPUT_VERB_RIGHT);
			
			var up_down =
				input_check_opposing_pressed(YUI_INPUT_VERB_UP, YUI_INPUT_VERB_DOWN)
				+ input_check_opposing_repeat(YUI_INPUT_VERB_UP, YUI_INPUT_VERB_DOWN);
	
			if up_down != 0 {
				if up_down < 0 moveFocus(YUI_FOCUS_DIRECTION.UP)
				else moveFocus(YUI_FOCUS_DIRECTION.DOWN)
			}
			else if left_right != 0 {
				if left_right < 0 moveFocus(YUI_FOCUS_DIRECTION.LEFT)
				else moveFocus(YUI_FOCUS_DIRECTION.RIGHT)
			}
		}
	}
}

// feather restore GM1044