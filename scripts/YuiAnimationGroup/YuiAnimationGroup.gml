/// @description here
function YuiAnimationGroup(anim_group_props, resources, slot_values) constructor {
	
	// resolve the animation value for each animatable property
	// and copy to new struct to avoid shared resource modification
	
	anim_properties = {};
	
	duration = 0;
	continuous = false;
	
	var names = variable_struct_get_names(anim_group_props);
	var i = 0; repeat array_length(names) {
		var name = names[i];
		var anim_props = anim_group_props[$ name];
		var anim = yui_resolve_animation(anim_props, resources, slot_values);
		anim_properties[$ name] = anim;
		
		// track the max duration
		duration = max(duration, anim.duration);
		
		// track if it's continuous
		continuous |= anim.continuous;
		
		i++;
	}
	
	static start = function(animatable) {
		// begin the animation for each property in the group
		var names = variable_struct_get_names(anim_properties);
		var i = 0; repeat array_length(names) {
			var name = names[i];
			var anim = anim_properties[$ name];
			target = animatable[$ name];
			target.beginAnimation(anim);
			i++;
		}
	}
}