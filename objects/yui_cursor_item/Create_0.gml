/// @description init

// NOTE: use this object as a parent object for any objects that
// should participate in YUI Cursor behavior (click/drag/etc)

// Whether this item participates in focus behavior
// (e.g. for keyboard/gamepad menu navigation)
focusable = false;

// whether this item is currently focused (managed by YuiCursorManager)
focused = false;

// render item for any interactions this participates in
interaction_item = undefined;

// whether this object acts as a cursor layer, which prevents mouse events
// from propagating to instances below it
is_cursor_layer = false;

// TODO: convert to cursor_click?
left_pressed = undefined;
left_click = undefined;

right_pressed = undefined;
right_click = undefined;

cursor_hover = undefined;

on_mouse_wheel_up = undefined;
on_mouse_wheel_down = undefined;

on_got_focus = undefined;
on_lost_focus = undefined;

// simplifies logic for checking parent opacity
opacity = 1;

onChildLayoutComplete = function(child) {
	// this is just here to make the recursive call simpler in yui_elements
}
setHighlight = function(highlight) {
	self.highlight = highlight;
}

