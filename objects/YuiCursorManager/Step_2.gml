/// @description

//if false var ref = __input_config_verbs;

if YUI_INPUT_LIB_ENABLED && is_navigation_active {
		
	if input_check_released(YUI_INPUT_VERB_ACCEPT) {
		activateFocused();
	}
	else {
		// focus only moves if we did *not* activate the previous focus this frame
		// (otherwise it would be nonsensical which thing was activated vs rendered as focused)
		
		// 4 directional support
		// FUTURE: diagonal support for gamepads?
		
		// add pressed and repeat to catch both initial and repeated inputs 
		// (which allows e.g. holding a direction to scroll through a list)
		
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







