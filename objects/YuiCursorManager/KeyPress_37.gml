/// @description move focus left

if !focused_item {
	return;
}

var next_item = yui_find_focus_item(
	focused_item,
	focus_list,
	YUI_FOCUS_DIRECTION.LEFT,
	is_focus_precise);

if next_item {
	setFocus(next_item);
}