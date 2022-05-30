/// @description find a Render Item by its object type and id
function yui_find_item_by_id(render_object_index, id) {
	with render_object_index {
		if _id == id {
			return self;
		}
	}
}
