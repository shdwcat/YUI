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
	
	static init = function(data, animatables) {
		var names = variable_struct_get_names(anim_properties);
		var i = 0; repeat array_length(names) {
			var name = names[i];
			var anim_property = anim_properties[$name];
			
			var animatable = animatables[$name];
			if animatable == undefined
				throw yui_error($"YuiAnimationGroup: '{animatables.type}' does not have animatable property '{name}'");
				
			// if the animation doesn't specify a 'from' value, we'll default to whatever the current
			// animated value is. This means that we can chain a sequence of animations specifying only
			// the 'to' value and the result will animate from one value to the next.
			var current_value = animatable.value;
			
			// resolve bindings
			anim_property.init(data, /* default from */ current_value, /* default to */ undefined);
			
			if anim_property.enabled {
				// track the max duration
				duration = max(duration, anim_property.duration + anim_property.delay);
		
				// track if it's continuous
				continuous |= anim_property.continuous;
			}
			
			i++;
		}
	}
	
	static start = function(animatable, owner, postInitCallback = undefined) {
		
		// TODO these really need to switch to starting an animation instance rather than
		// modifying themselves -- currently the anims aren't being used in a shared way
		// but will have problems if they ever are
		// When that's done we can modify the instance after creation, before running,
		// in order to address the postInitCallback hackiness in a better way
		
		// call init to resolve bindings (e.g. duration and continuous)
		init(owner.data_source, animatable);
		
		// very hacky way to allow customizing the results after the init
		if postInitCallback
			postInitCallback(self);
		
		// begin the animation for each property in the group
		var names = variable_struct_get_names(anim_properties);
		var i = 0; repeat array_length(names) {
			var name = names[i];
			var anim = anim_properties[$ name];
			
			if anim.enabled {
				var target = animatable[$ name];
				target.beginAnimation(anim);
			}
			
			i++;
		}
	}
}