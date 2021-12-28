/// @description define cursor events

// NOTE: use this object as a parent object for any objects that
// should participate in YUI Cursor behavior (click/drag/etc)

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

onChildLayoutComplete = function(child) {
	// this is just here to make the recursive call simpler in yui_renderers
}