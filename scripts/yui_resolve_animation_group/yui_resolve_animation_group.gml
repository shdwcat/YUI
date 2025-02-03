function yui_resolve_animation_group(anim_group_props, resources, slot_values) {
	if anim_group_props == undefined
		return undefined;
	
	// automatically turn an array of animation groups into an AnimationGroupSequence
	if is_array(anim_group_props) {
		var sequence_props = { animations: anim_group_props };
		return new YuiAnimationGroupSequence(sequence_props, resources, slot_values);
	}
	
	// check if an anim group type was specified
	if variable_struct_exists(anim_group_props, "type") {
		switch anim_group_props.type {
			case "anim_sequence":
				return new YuiAnimationGroupSequence(anim_group_props, resources, slot_values);
			default:
				throw yui_error("Unknown animation group type:" + string(type));
		}
	}
	
	// if no type was specified, default to regular animation group
	return new YuiAnimationGroup(anim_group_props, resources, slot_values);
}