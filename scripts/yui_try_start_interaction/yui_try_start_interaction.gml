/// @description starts an interaction if it is valid to do so (via checking interaction.canStart())
function yui_try_start_interaction(interaction, source_data, event) {
	
	if is_string(interaction) {
		
		if !variable_struct_exists(YuiCursorManager.interaction_map, interaction) {
			if debug_mode {
				show_message("Could not find interaction with name: " + interaction);
			}
			return false;
		}
		
		interaction = YuiCursorManager.interaction_map[$ interaction];
	}

	var can_start = interaction.canStart(source_data);
	if !can_start return false;
	
	yui_log("starting", interaction.props.type, "interaction");
	
	var element = interaction.start(source_data, event, self);
	if element {
		YuiCursorManager.visual_item = yui_make_render_instance(element, interaction, , 100);
		YuiCursorManager.visual_item.arrange({
			x: device_mouse_x_to_gui(0),
			y: device_mouse_y_to_gui(0),
			w: window_get_width(),
			h: window_get_height(),
		})
	}
	
	YuiCursorManager.active_interaction = interaction;
	return true;
}