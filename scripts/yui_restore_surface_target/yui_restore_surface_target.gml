/// @description restores the previous surface target
function yui_restore_surface_target(old_surface) {
	// reset the render target
	surface_reset_target();
	if old_surface surface_set_target(old_surface);
}