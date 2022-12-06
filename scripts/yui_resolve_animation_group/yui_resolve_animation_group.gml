/// @description here
function yui_resolve_animation_group(anim_group_props, resources, slot_values) {
	
	// resolve the animation value for each animatable property
	// and copy to new struct to avoid shared resource modification
	
	var anim_group = {};
	
	var names = variable_struct_get_names(anim_group_props);
	var i = 0; repeat array_length(names) {
		var name = names[i];
		var anim_props = anim_group_props[$ name];
		var anim = yui_resolve_animation(anim_props, resources, slot_values);
		anim_group[$ name] = anim;
		i++;
	}
	
	return anim_group;
}