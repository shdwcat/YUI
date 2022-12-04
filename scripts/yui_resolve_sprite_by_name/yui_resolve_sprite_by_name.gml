/// @description resolve a sprite name to either a named sprite, or a sprite resource
function yui_resolve_sprite_by_name(sprite_name, resources = undefined) {
	if sprite_name == undefined return undefined;
	
	// just return it if it's a sprite
	if is_numeric(sprite_name) && sprite_exists(sprite_name) {
		return sprite_name;
	}
	
	var sprite = asset_get_index(sprite_name);
	
	//if sprite == -1 && resources != undefined {
	//	// check for dynamic sprite resource
	//	// TODO: we could do this when initially resolving resource imports (via flag on the struct?)
	//	var sprite_resource = resources[$ sprite_name];
	//	if is_struct(sprite_resource) {
	//		if sprite_resource.type == "dynamic_sprite" {
	//			sprite = yui_create_dynamic_sprite(sprite_resource);
				
	//			// update the resource so we don't have to create it again
	//			resources[$ sprite_name] = sprite;
	//		}
	//		else {
	//			sprite = -1;
	//			yui_error("Sprite resource entry", sprite_name, "is not a dynamic_sprite struct");
	//		}
	//	}
	//	else if sprite_exists(sprite_resource) {
	//		sprite = sprite_resource;
	//	}
	//	else {
	//		sprite = -1;
	//		yui_error("sprite resource entry", sprite_name, "did not resolve to a struct");
	//	}
	//}
	
	if sprite == -1 sprite = undefined;
	
	return sprite;
}