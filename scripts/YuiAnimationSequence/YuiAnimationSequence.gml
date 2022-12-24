/// @description here
function YuiAnimationSequence(props, resources, slot_values) constructor {
	static default_props = {
		type: "anim_sequence",
		enabled: true,
		"repeat": false,
		animations: undefined,
		"global": true,
	}
	
	self.props = props;
	
	enabled = yui_bind_and_resolve(props[$"enabled"], resources, slot_values) ?? true;
	continuous = yui_bind_and_resolve(props[$"repeat"], resources, slot_values) ?? false;
	animations = yui_bind_and_resolve(props[$"animations"], resources, slot_values) ?? false;
	anim_count = array_length(animations);
	
	time_source = props[$"global"] == true ? time_source_global : time_source_game;
	
	if !is_array(animations)
		throw yui_error("anim_sequence.animations must be an array");
	
	// resolve inner animation groups
	var i = 0; repeat anim_count {
		var anim_group_props = animations[i];
		var anim_group = yui_resolve_animation_group(anim_group_props, resources, slot_values);
		
		// disallow nested continuous animations (because the sequence would never continue after one)
		if anim_group.continuous
			throw yui_error("Animations in a sequence cannot repeat. If you want the sequence to repeat, set 'repeat: true' on the sequence itself.");
		
		animations[i++] = anim_group;
	}
	
	static start = function(animatable) {
		startAnimStep(self, animatable, 0);
	}
	
	static startAnimStep = function(sequence, animatable, index) {
		with sequence {
			var anim_group = animations[index];
			anim_group.start(animatable);
			
			var finished = ++index >= anim_count;
			
			// reset to start if the animation should repeat
			if finished && continuous {
				finished = false;
				index = 0;
			}
			
			if !finished {
				var ts = time_source_create(
					time_source,
					anim_group.duration / 1000,
					time_source_units_seconds,
					startAnimStep,
					[sequence, animatable, index],
					1, // run once
					time_source_expire_after);
					
				time_source_start(ts);
			}
		}
	}
}