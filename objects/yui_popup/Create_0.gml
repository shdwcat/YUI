/// @description init

// Inherit the parent event
event_inherited();

border_arrange = arrange;
/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	border_arrange(available_size, viewport_size);
	
	// the size of the parent item does not depend on the size of the popup
	// so we can ignore that here
	is_size_changed = false;
	
	// align popup
	if visible
		yui_align_from_placement(self, bound_values.placement);
}