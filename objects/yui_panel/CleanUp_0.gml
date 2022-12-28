/// @description base + clear child array

// Inherit the parent event
event_inherited();

// need to clear out the children list once destroyed
// (when closing the game, the runtime may run this code
// multiple times for the same instance, unclear why)
internal_children = [];