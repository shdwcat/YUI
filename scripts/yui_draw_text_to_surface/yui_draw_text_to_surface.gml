/// @description draws text to a provided surface (or creates it if needed)
function yui_draw_text_to_surface(
	w, h, text, text_w, color, opacity, font, surface_id = undefined) {
		
	if surface_id == undefined || !surface_exists(surface_id){
		surface_id = surface_create(w, h);
	}
	else {
		if w != surface_get_width(surface_id)
		|| h != surface_get_height(surface_id) {
			surface_resize(surface_id, w, h);
		}
	}
		
	var old_surface = surface_get_target();
	var old_font = draw_get_font();
	
	surface_set_target(surface_id);
	draw_clear_alpha(c_black, 0);
	
	draw_set_font(font);
	
	draw_text_ext_color(
		0, 0,
		text, -1, text_w,
		color, color, color, color, opacity);
	
	if old_surface > 0 && old_surface != application_surface {
		surface_set_target(old_surface);
	}
	else {
		surface_reset_target();
	}
	
	draw_set_font(old_font);
	
	
	return surface_id;
}