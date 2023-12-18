/// @description init

// use single pixel + sizing with instance_place_list in step event
sprite_index = yui_white_pixel

// ===== interactions =====

// hash of interaction.role strings to ids
participation_hash = new YuiStringHashMap("participation_hash");

// tracks instances participating in an interaction.role
participation_map = ds_map_create();

active_interaction = undefined;
visual_item = undefined;

// offset of actual cursor from point to check (e.g. when dragging an item)
cursor_offset_x = 0;
cursor_offset_y = 0;

finishInteraction = function() {
	yui_log($"interaction {active_interaction.props.type} complete");
	if visual_item {
		yui_log($"unloading interaction visual {visual_item}");
		visual_item.unload();
		cursor_offset_x = 0;
		cursor_offset_y = 0;
		visual_item = undefined;
	}
	active_interaction = undefined;
}

// ===== cursor =====

// which item has keyboard/gamepad focus
focused_item = undefined;

// for use with finding next focus item
focus_list = ds_list_create();

// which focus scope is currently active
active_focus_scope = "global";

// map of focus scopes to focused item in that scope
focus_scope_map = {
	global: undefined,
};

// stack used to track focus scope navigation
focus_scope_stack = ds_stack_create();

// list for tracking hover items for mouseover logic
hover_list = ds_list_create();
hover_count = 0;
hover_array = [];

// tracking highlight
highlight_map = ds_map_create();

// arrays for tracking mouse down->up on same item
mouse_down_array = [];
mouse_down_array[mb_left] = [];
mouse_down_array[mb_middle] = [];
mouse_down_array[mb_right] = [];
mouse_down_array[mb_side1] = [];
mouse_down_array[mb_side2] = [];

left_pressed_consumed = false;
left_click_consumed = false;
right_pressed_consumed = false;
right_click_consumed = false;
wheel_down_consumed = false;
wheel_up_consumed = false;

// events to handle mouse interaction if YUI screen has not handled it
// NOTE: only supports one subscriber!
global_left_pressed = undefined;
global_wheel_up = undefined
global_wheel_down = undefined
// TODO: global versions of all events

setFocus = function(focus_item, new_scope = undefined) {
	
	// check if new focus is different from current
	if focus_item == focused_item return;
	
	// trigger lost focus
	if focused_item && instance_exists(focused_item) {
		if focused_item.on_lost_focus focused_item.on_lost_focus();
		focused_item.focused = false;
	}
	
	focused_item = focus_item;
	
	// set the new focus scope if one is provided
	if new_scope && new_scope != active_focus_scope {
		active_focus_scope = new_scope;
		
		// place it on the stack for when we exit this scope
		ds_stack_push(focus_scope_stack, new_scope);
	}
	
	focus_scope_map[$ active_focus_scope] = focused_item;
	
	// trigger got focus
	if focused_item && instance_exists(focused_item) {
		if focused_item.on_got_focus focused_item.on_got_focus();
		focused_item.focused = true;
	}
}

moveFocus = function(direction = YUI_FOCUS_DIRECTION.DOWN) {
	var next_item = yui_find_focus_item(
		focused_item,
		focus_list,
		direction,
		is_focus_precise); // TODO move to macro

	if next_item {
		setFocus(next_item);
	}
	else if direction != YUI_FOCUS_DIRECTION.UP {
		moveFocus(YUI_FOCUS_DIRECTION.UP);
	}
	else {
		clearFocus();
	}
}

clearFocus = function() {
	// TODO: this should try to find the previous focus item in scope,
	// or kick up the focus stack
	setFocus(undefined);
}

trackMouseDownItems = function(button) {
	array_resize(mouse_down_array[button], hover_count);
	var i = hover_count - 1; repeat hover_count {
		var item = hover_list[|i];
		var type = object_get_name(item.object_index);
		//yui_log("mouse down on:", item, " - ", type, " - ", item[$" _id"]);
		mouse_down_array[button][i] = item;
		i--;
	}
}

isCursorOnVisiblePart = function(item) {
	return item.isPointVisible(mouse_x + cursor_offset_x, mouse_y + cursor_offset_y);
}

// track delayed events like double click

double_click_start_time = 0;
click_count = 0;

queued_event = undefined;
queued_target = undefined;
queued_method = undefined;

queueEvent = function(name, target, method, delay_ms) {
	queued_event = name;
	queued_target = target;
	queued_method = method;
	
	// convert milliseconds to game steps
	// room_speed = steps per second
	var steps = ceil(room_speed * (delay_ms / 1000));
	yui_log($"queueing event {name} with delay ms {delay_ms}");
	alarm_set(0, steps);
}

clearQueuedEvent = function() {
	double_click_start_time = 0;
	click_count = 0;
	queued_event = undefined;
	queued_target = undefined;
	queued_method = undefined;
	alarm_set(0, -1)
}

