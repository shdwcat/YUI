/// @description draw an alpha-enabled surface part
function yui_draw_alpha_surface_part(surface, left, top, width, height, x, y) {

	var bm = gpu_get_blendmode_ext();
	
	// pre-multiply alpha!!!
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	draw_surface_part(surface, left, top, width, height, x, y);
	
	gpu_set_blendmode_ext(bm[0], bm[1]);
}