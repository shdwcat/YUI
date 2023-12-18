/// @description here
function YuiAnimationGroup(anim_group_props, resources, slot_values) constructor {
	
	anim_properties = {};
	
	enabled = true;
	duration = 0;
	continuous = false;
	
	var names = variable_struct_get_names(anim_group_props);
	var i = 0; repeat array_length(names) {
		var name = names[i];
		var anim_props = anim_group_props[$ name];
		var anim = yui_resolve_animation(anim_props, resources, slot_values);
		anim_properties[$ name] = anim;
		i++;
	}
	
	static init = function(data) {
		var names = variable_struct_get_names(anim_properties);
		var i = 0; repeat array_length(names) {
			var name = names[i];
			var anim = anim_properties[$name];
			
			// resolve bindings
			anim.init(data);
		
			// track the max duration
			duration = max(duration, anim.duration + anim.delay);
		
			// track if it's continuous
			continuous |= anim.continuous;
		
			i++;
		}
	}
	
	static start = function(animatable, owner) {
		// call init to resolve bindings (e.g. duration and continuous)
		init(owner.data_source);
		
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