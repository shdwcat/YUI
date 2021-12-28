/// @description gets an array of the instances participating in an interaction.role
function yui_get_interaction_participants(interaction_role_id) {
	var inner_map = YuiCursorManager.participation_map[? interaction_role_id];
	
	// return the participating instances or an empty array if there are none
	return inner_map == undefined ? [] : ds_map_keys_to_array(inner_map);
}