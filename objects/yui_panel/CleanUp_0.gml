/// @description base + clear child array

// Inherit the parent event
event_inherited();

if recycling_lookup != undefined
	ds_map_destroy(recycling_lookup);

// need to clear out the children list once destroyed
// (when closing the game, the runtime may run this code
// multiple times for the same instance, unclear why)
internal_children = [];