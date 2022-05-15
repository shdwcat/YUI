/// @description draws text to a provided surface (or creates it if needed)
function yui_draw_text_to_surface(
	x, y, w, h, text, text_w, color, opacity, halign, valign, font, surface_id = undefined) {
		
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
	var old_halign = draw_get_halign();
	var old_valign = draw_get_valign();
	
	surface_set_target(surface_id);	
	draw_clear_alpha(c_black, 0);
	
	draw_set_font(font);
	draw_set_halign(halign);
	draw_set_valign(valign);
	
	draw_text_ext_color(
		x, y,
		text, -1, text_w,
		color, color, color, color, opacity);
	
	if old_surface > 1 {
		surface_set_target(old_surface);
	}
	else {
		surface_reset_target();
	}
	
	draw_set_font(old_font);
	draw_set_halign(old_halign);
	draw_set_valign(old_valign);
	
	
	return surface_id;
}