/// @description starts an interaction if it is valid to do so (via checking interaction.canStart())
function yui_try_start_interaction(interaction, source_data, event, source_element, ro_context) {

	var can_start = interaction.canStart(ro_context, source_data);
	if !can_start return false;
	
	YuiCursorManager.active_interaction = interaction;
	interaction.start(source_data, source_element, event);
	return true;
}