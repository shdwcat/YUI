/// @description clean up children

event_inherited();

var i = 0; repeat array_length(internal_children) {
	var instance = internal_children[i];
	//yui_log("destroying panel child (index ", i, ") visual", instance.id);
	instance_destroy(instance.id);
	i++;
}