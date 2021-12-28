/// @description init

hover_list = ds_list_create();
hover_count = 0;

left_pressed_consumed = false;
left_clicked_consumed = false;

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

top = function() {
	return hover_count > 0 ? hover_list[| hover_count - 1] : undefined;
}

finishInteraction = function() {
	yui_log("interaction", active_interaction.props.type, "complete");
	if visual_item {
		//yui_log("destroying interaction visual", visual_item);
		instance_destroy(visual_item);
		visual_item = undefined;
	}
	active_interaction = undefined;
}