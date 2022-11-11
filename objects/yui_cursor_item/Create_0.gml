/// @description init

// NOTE: use this object as a parent object for any objects that
// should participate in YUI Cursor behavior (click/drag/etc)

// Whether this item participates in focus behavior
// (e.g. for keyboard/gamepad menu navigation)
focusable = false;

// whether this item is currently focused (managed by YuiCursorManager)
focused = false;

// whether the cursor is over this item
highlight = false;

// render item for any interactions this participates in
interaction_item = undefined;

// whether this object acts as a cursor layer, which prevents mouse events
// from propagating to instances below it
is_cursor_layer = false;

// TODO: convert to cursor_click?
left_pressed = undefined;
left_click = undefined;
left_double_click = undefined;

right_pressed = undefined;
right_click = undefined;
right_double_click = undefined;

cursor_hover = undefined;

on_mouse_wheel_up = undefined;
on_mouse_wheel_down = undefined;

on_got_focus = undefined;
on_lost_focus = undefined;

on_hover_changed = undefined;

// simplifies logic for checking parent opacity
opacity = 1;

onChildLayoutComplete = function(child) {
	// this is just here to make the recursive call simpler in yui_elements
}

setHighlight = function(highlight) {
	var changed = self.highlight != highlight;
	self.highlight = highlight;
	
	if changed && on_hover_changed {
		on_hover_changed();
	}
}



