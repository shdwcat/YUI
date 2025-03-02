/// @description init

// Inherit the parent event
event_inherited();

border_arrange = arrange;
/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	border_arrange(available_size, viewport_size);
	
	// align popup
	yui_align_from_placement(self, bound_values.placement);
}