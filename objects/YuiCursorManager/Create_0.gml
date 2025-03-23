/// @description init

// input lib setup
if YUI_INPUT_LIB_ENABLED __yui_init_input_lib();

// use single pixel + sizing with instance_place_list in step event
sprite_index = yui_white_pixel;

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

// variables for Input 6 library support
is_navigation_active = YUI_DEFAULT_IS_NAVIGATION_ACTIVE; // whether YUI should check for inputs and update focus

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

// which YuiFocusScope the focused_item is in
active_focus_scope = undefined;

// for use with finding next focus item
focus_list = ds_list_create();

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

// which elements consumed the events
left_pressed_consumer = false;

// events to handle mouse interaction if YUI screen has not handled it
// NOTE: only supports one subscriber!
global_left_pressed = undefined;
global_wheel_up = undefined
global_wheel_down = undefined
// TODO: global versions of all events

setFocus = function(focus_item) {
	
	// check if new focus is different from current
	if focus_item == focused_item return;
	
	// skip if item is not focusable
	if focus_item && !focus_item.focusable return;
	
	// trigger lost focus
	if focused_item && instance_exists(focused_item) {
		if focused_item.on_lost_focus focused_item.on_lost_focus();
		focused_item.focused = false;
	}
	
	// TODO: is this where focus scopes get checked before focusing or is that in yui_find_focus_item?
	
	focused_item = focus_item;
	
	if focused_item && instance_exists(focused_item) {
		// track the new focus scope and focus the item within it
		active_focus_scope = focused_item.focus_scope;
		active_focus_scope.focus(focused_item);
	}
	else {
		active_focus_scope = undefined;
	}
}

moveFocus = function(direction = YUI_FOCUS_DIRECTION.DOWN) {
	var current_item = focused_item;

	// if the current item is not valid, autofocus the active scope
	var is_current_item_valid = current_item && instance_exists(current_item);
	if !is_current_item_valid && active_focus_scope {
		active_focus_scope.doAutofocus();
		exit;
	}

	var next_item = yui_find_focus_item(
		current_item,
		focus_list,
		direction,
		is_focus_precise); // TODO move to macro?

	if next_item {
		setFocus(next_item);
	}
}

clearFocus = function() {
	setFocus(undefined);
}

tryAutofocus = function(target, is_focus_root) {
	// NOTE: assumes item is focusable (checked at single callsite to this function)
		
	if !is_focus_root {
		// we will focus this item if it has autofocus: true OR there is no focused item at all
		if target.autofocus || focused_item == undefined || !instance_exists(focused_item) {
			if is_navigation_active {
				setFocus(target);
			}
		}
	}
	
	if is_focus_root {
		var parent_scope = target.focus_scope.parent;
		if parent_scope
			parent_scope.autofocus_target ??= target.focus_scope;
	}
	else {
		if target.focus_scope.autofocus_target == undefined {
			target.focus_scope.autofocus_target = target;
		
			active_focus_scope ??= target.focus_scope;
		}
	}
}

activateFocused = function() {
	if focused_item && instance_exists(focused_item) && focused_item.left_click != undefined {
		focused_item.left_click();
	}
}

trackMouseDownItems = function(button) {
	array_resize(mouse_down_array[button], hover_count);
	var i = 0; repeat hover_count {
		var item = hover_list[|i];
		//var type = object_get_name(item.object_index);
		//yui_log("mouse down on:", item, " - ", type, " - ", item[$" _id"]);
		mouse_down_array[button][i] = item;
		i++;
	}
}

isCursorOnVisiblePart = function(item) {
	if !object_is_ancestor(item.object_index, yui_base) return true;
	
	return item.isPointVisible(mouse_x + cursor_offset_x, mouse_y + cursor_offset_y);
}

onKeyLeft = function() {
	// trigger normal keypress handling first
	if focused_item && instance_exists(focused_item)
		&& focused_item.onKeyPressed && focused_item.onKeyPressed(vk_left) return;

	moveFocus(YUI_FOCUS_DIRECTION.LEFT);
}

onKeyRight = function() {
	// trigger normal keypress handling first
	if focused_item && instance_exists(focused_item)
		&& focused_item.onKeyPressed && focused_item.onKeyPressed(vk_right) return;

	moveFocus(YUI_FOCUS_DIRECTION.RIGHT);
}

onKeyUp = function() {
	// trigger normal keypress handling first
	if focused_item && instance_exists(focused_item)
		&& focused_item.onKeyPressed && focused_item.onKeyPressed(vk_up) return;

	moveFocus(YUI_FOCUS_DIRECTION.UP);
}

onKeyDown = function() {
	// trigger normal keypress handling first
	if focused_item && instance_exists(focused_item)
		&& focused_item.onKeyPressed && focused_item.onKeyPressed(vk_down) return;

	moveFocus(YUI_FOCUS_DIRECTION.DOWN);
}

onCursorWheelUp = function() {
	var wheel_up_consumed = false;
	var i = 0; repeat hover_count {
		var next = hover_array[i];
	
		if instance_exists(next) && isCursorOnVisiblePart(next) {
			if next.on_mouse_wheel_up {
				wheel_up_consumed = next.on_mouse_wheel_up() != false;
				if wheel_up_consumed {
					break;
				}
			}
	
			// a cursor layer blocks all events from propagating below it
			// e.g. popups and windows
			if next.is_cursor_layer {
				break;
			}
		}
	
		i++;
	}

	if !wheel_up_consumed && global_wheel_up {
		// Feather disable once GM1021
		global_wheel_up();
	}
}

onCursorWheelDown = function() {
	var wheel_down_consumed = false;
	var i = 0; repeat hover_count {
		var next = hover_array[i];
	
		if instance_exists(next) && isCursorOnVisiblePart(next) {
			if next.on_mouse_wheel_down {
				wheel_down_consumed = next.on_mouse_wheel_down() != false;
				if wheel_down_consumed {
					break;
				}
			}
	
			// a cursor layer blocks all events from propagating below it
			// e.g. popdowns and windows
			if next.is_cursor_layer {
				wheel_down_consumed = true;
				break;
			}
		}
	
		i++;
	}

	if !wheel_down_consumed && global_wheel_down {
		// Feather disable once GM1021
		global_wheel_down();
	}
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
	var steps = ceil(game_get_speed(gamespeed_fps) * (delay_ms / 1000));
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