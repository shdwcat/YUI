/// @description resolve a sprite name to either a named sprite, or a sprite resource
function yui_resolve_sprite_by_name(sprite_name, resources = undefined) {
	if sprite_name == undefined return undefined;
	
	// just return it if it's a sprite
	if is_numeric(sprite_name) && sprite_exists(sprite_name) {
		return sprite_name;
	}
	
	var sprite = asset_get_index(sprite_name);
	if sprite == -1 sprite = undefined;
	
	return sprite;
}