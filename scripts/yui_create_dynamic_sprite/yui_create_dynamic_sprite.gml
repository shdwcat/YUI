/// @description creates a sprite at runtime from the sprite_resource definition
function yui_create_dynamic_sprite(sprite_resource) {

	var sprite_asset = asset_get_index(sprite_resource.sprite_name);
	var frame = sprite_resource[$ "frame"] || 0;
	
	
	var w = sprite_get_width(sprite_asset);
	var h = sprite_get_height(sprite_asset);
	
	var x_origin = sprite_get_xoffset(sprite_asset);
	var y_origin = sprite_get_yoffset(sprite_asset);
	
	var new_x_origin = x_origin;
	var new_y_origin = y_origin;
	
	var scale = sprite_resource[$ "scale"];
	if scale != undefined {
		w *= scale;
		h *= scale;
		new_x_origin *= scale;
		new_y_origin *= scale;
	}
	else {
		scale = 1;
	}
		
	var surface = surface_create(w, h);
		
	// store and reset the previous render target	
	var old_surface = surface_get_target();
	if old_surface surface_reset_target();
		
	// set and clear the new render target
	surface_set_target(surface);
	draw_clear_alpha(c_black, 0);
				
	draw_sprite_ext(sprite_asset, frame, new_x_origin, new_y_origin, scale, scale, 0, c_white, 1);
	//draw_rectangle_color(0,0, w, h, c_red, c_red, c_red, c_red, false);
		
	// reset the render target
	surface_reset_target();
	if old_surface surface_set_target(old_surface);	
	
	var new_sprite_index = sprite_create_from_surface(
		surface, 0, 0, w, h,
		false, false, new_x_origin, new_y_origin);
	
	// release the surface
	surface_free(surface);
	
	return new_sprite_index;
}