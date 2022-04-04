/// @description returns the 'list' of parents of the provided item (as a map)
/// @param render_item the item to check for parents
/// @param [type_object_index] if provided, includes only parents of the specified type
function yui_get_item_parent_map(render_item, type_object_index = yui_base) {
	
	var map = ds_map_create();
	var item = render_item;
	
	// if a parent exists, check if it's the right type
	while item.parent {
		item = item.parent;
		
		// if the (parent) item is the right type, add it to the map
		if object_is_ancestor(item.object_index, type_object_index) {			
			map[? item] = item;
		}
	}
	
	return map;
}