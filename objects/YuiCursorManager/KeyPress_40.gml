/// @description move focus down

if !focused_item {
	DEBUG_BREAK_YUI;
}

// also need to check for a 'navigate_down' event, in case we wanted to override
// the arrow behavior, e.g. for entering a submenu

var next_item = yui_find_focus_item(
	focused_item,
	focus_list,
	YUI_FOCUS_DIRECTION.DOWN,
	is_focus_precise); // TODO move to macro

if next_item {
	setFocus(next_item);
}