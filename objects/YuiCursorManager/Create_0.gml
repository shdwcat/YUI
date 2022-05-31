/// @description init

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

// hash of interaction.role strings to ids
participation_hash = new YuiStringHashMap("participation_hash");

// tracks instances participating in an interaction.role
participation_map = ds_map_create();

// the map of interaction names to interactions
interaction_map = yui_load_interactions();

// hack to make o_camera_panner work
// NOTE: only supports one subscriber!
global_left_pressed = undefined;

active_interaction = undefined;
visual_item = undefined;

// check if this instance is at the top of the hover stack
isMouseOver = function() {
	return hover_count > 0 && hover_list[| hover_count - 1] == other.id;
}

//top = function() {
//	return hover_count > 0 ? hover_list[| hover_count - 1] : undefined;
//}

finishInteraction = function() {
	yui_log("interaction", active_interaction.props.type, "complete");
	if visual_item {
		yui_log("destroying interaction visual", visual_item);
		instance_destroy(visual_item);
		visual_item = undefined;
	}
	active_interaction = undefined;
}

setFocus = function(focus_item, new_scope = undefined) {
	
	// trigger lost focus
	if focused_item && instance_exists(focused_item) && focused_item.on_lost_focus {
		focused_item.on_lost_focus();
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
	if focused_item && instance_exists(focused_item) && focused_item.on_got_focus {
		focused_item.on_got_focus();
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
		setFocus(undefined);
	}
}

trackMouseDownItems = function(button) {
	array_resize(mouse_down_array[button], hover_count);
	var i = hover_count - 1; repeat hover_count {
		yui_log("mouse down on:", hover_list[|i]);
		mouse_down_array[button][i] = hover_list[| i];
		i--;
	}
}

