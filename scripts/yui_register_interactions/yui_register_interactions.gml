/// @description register interaction participation
function yui_register_interactions(interactions, should_hash_items = false) {
	
	if should_hash_items {
		YuiCursorManager.participation_hash.hashArray(interactions);
	}

	if array_length(interactions) > 0 {
		var i = 0; repeat array_length(interactions) {
			var interaction = interactions[i++];
			var inner_map = YuiCursorManager.participation_map[? interaction];
		
			// make the map if this is the first instance to register this interaction
			if inner_map == undefined {
				inner_map = ds_map_create();
				YuiCursorManager.participation_map[? interaction] = inner_map;
			}
		
			// NOTE: we're using the inner map as a set of object instances
			var added = ds_map_add(inner_map, self.id, true);
			if !added {
				throw yui_error("re-registering interaction");
			}
		}
	}
}

/// @description unregister interaction participation
function yui_unregister_interactions(interactions) {
	
	if !ds_exists(YuiCursorManager.participation_map, ds_type_map) return;

	var i = 0; repeat array_length(interactions) {
		var interaction = interactions[i++];
		var inner_map = YuiCursorManager.participation_map[? interaction];
		
		if inner_map == undefined {
			throw yui_error("attempting to unregister interaction that was not registered")
		}
		
		// clean up
		ds_map_delete(inner_map, self.id);
		if ds_map_empty(inner_map) {
			ds_map_destroy(inner_map);
			ds_map_delete(YuiCursorManager.participation_map, interaction);
		}
	}
}