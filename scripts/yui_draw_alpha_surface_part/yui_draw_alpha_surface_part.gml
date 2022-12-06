/// @description draw an alpha-enabled surface part
function yui_draw_alpha_surface_part(surface, left, top, width, height, x, y, alpha) {

	var bm = gpu_get_blendmode_ext();
	
	// pre-multiply alpha!!!
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	// need a shader to actually make animated alpha work
	draw_surface_part_ext(surface, left, top, width, height, x, y, 1, 1, c_white, alpha);
	
	gpu_set_blendmode_ext(bm[0], bm[1]);
}