/// @description init

// Inherit the parent event
event_inherited();

// don't inherit parent enabled/opacity since we're on a new layer
inherit_enabled = false;
inherit_opacity = false;

border_arrange = arrange;
/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	border_arrange(available_size, viewport_size);
	
	// align popup
	yui_align_from_placement(self, bound_values.placement);
}