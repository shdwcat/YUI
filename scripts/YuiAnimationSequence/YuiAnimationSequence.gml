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
	
	static start = function(animatable, owner) {
		var owner_ref = weak_ref_create(owner);
		startAnimStep(self, animatable, owner_ref, 0);
	}
	
	static startAnimStep = function(sequence, animatable, owner_ref, index, previous_time_source = undefined) {
		
		// clean up previous time source (or framerate will suffer)
		if previous_time_source
			time_source_destroy(previous_time_source);
		
		with sequence {
			// start the current animation step
			var anim_group = animations[index];
			anim_group.start(animatable);
			
			// check if we're out of further animations
			var finished = ++index >= anim_count;
			
			// reset to start if the animation should repeat
			if finished && continuous {
				finished = false;
				index = 0;
			}
			
			finished |= weak_ref_alive(owner_ref) == false;
			
			if !weak_ref_alive(owner_ref)
				yui_log("owner no longer alive, ending animation sequence");
			
			
			if !finished {
				
				var duration_seconds = anim_group.duration / 1000;
				
				// create the time souce
				var time_source_id = time_source_create(
					time_source,
					duration_seconds,
					time_source_units_seconds,
					startAnimStep);
				
				// reconfigure it so that we can pass the time source ID to the callback
				time_source_reconfigure(
					time_source_id,
					duration_seconds,
					time_source_units_seconds,
					startAnimStep, [sequence, animatable, owner_ref, index, time_source_id],
					1, // run once
					time_source_expire_after);
					
				time_source_start(time_source_id);
			}
		}
	}
}