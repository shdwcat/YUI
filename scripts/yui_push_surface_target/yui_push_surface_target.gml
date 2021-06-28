/// @description switches to a new surface target and returns the new and old surface
function yui_push_surface_target(draw_rect, surface_lookup, surface_key){
	// set up the content surface
	var content_surface = surface_lookup[$ surface_key];
		
	if !is_undefined(content_surface) && surface_exists(content_surface) {
		var needs_resize =
			draw_rect.w != surface_get_width(content_surface)
			|| draw_rect.h != surface_get_height(content_surface);
		if needs_resize 
			surface_resize(content_surface, draw_rect.w, draw_rect.h);
	}
	else {
		content_surface = surface_create(draw_rect.w, draw_rect.h);
		surface_lookup[$ surface_key] = content_surface;
	}
			
	// store and reset the previous render target		
	var old_surface = surface_get_target();
	if old_surface surface_reset_target();
		
	// set and clear the new render target
	surface_set_target(content_surface);
	draw_clear_alpha(c_black, 0);
	
	return {
		old_surface: old_surface,
		content_surface: content_surface,
	}
}