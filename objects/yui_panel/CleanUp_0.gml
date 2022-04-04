/// @description clean up children

event_inherited();

var i = 0; repeat array_length(internal_children) {
	var instance = internal_children[i];
	//yui_log("destroying panel child (index ", i, ") visual", instance.id);
	instance_destroy(instance.id);
	i++;
}

// need to clear out the children list once destroyed
// (when closing the game, the runtime may run this code
// multiple times for the same instance, unclear why)
internal_children = [];