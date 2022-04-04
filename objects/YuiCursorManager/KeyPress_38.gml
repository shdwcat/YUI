/// @description move focus up

if !focused_item {
	DEBUG_BREAK_YUI;
}

var next_item = yui_find_focus_item(
	focused_item,
	focus_list,
	YUI_FOCUS_DIRECTION.UP,
	is_focus_precise);

if next_item {
	setFocus(next_item);
}