/// @description draw an alpha-enabled surface
function yui_draw_alpha_surface(surface, x, y) {
	var bm = gpu_get_blendmode_ext();
	
	// pre-multiply alpha!!!
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	draw_surface(surface, x, y);
	
	gpu_set_blendmode_ext(bm[0], bm[1]);
}
