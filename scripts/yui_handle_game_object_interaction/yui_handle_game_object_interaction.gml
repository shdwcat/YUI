/// @description here
function yui_handle_game_object_interaction(interaction, render_context) {
	var participation = interaction.props[$ "game_object_participation"];
	if participation == undefined return;

	// loop over the game objects that are defined as participating
	var keys = variable_struct_get_names(participation);
	var i = 0; repeat array_length(keys) {
		var key = keys[i++];
		
		if asset_get_type(key) != asset_object {
			throw string_concat("object name", key, "did not resolve to a game object index");
		}
		
		var object_asset_index = asset_get_index(key);		
		var object_participation = participation[$ key];
		
		// loop over each instance of the specified object index and call inteaction.updateTarget()
		var item_index = 0;
		with (object_asset_index) {
			var instance = self;
			var target_rect = {
				x: x,
				y: y,
				w: bbox_right - bbox_left,
				h: bbox_bottom - bbox_top,
			};
			interaction.updateTarget(
				render_context,
				instance,
				target_rect,
				object_participation,
				item_index++);
		}
	}
}