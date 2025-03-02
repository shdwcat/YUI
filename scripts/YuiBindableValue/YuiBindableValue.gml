// feather ignore GM2017

/// @description wraps a YuiExpr to store the value and check for changes
function YuiBindableValue(binding, default_anim) constructor {
	
	self.default_anim = default_anim;
	
	is_live = false;
	
	self.value = undefined;
		
	self.animation = undefined;
	self.animation_start_time = undefined;
	self.animation_start_value = undefined;
	self.animation_step = undefined;
	self.animation_state = undefined;
	
	self.prev_animation = undefined;
	self.prev_animation_start_time = undefined;
	self.prev_animation_start_value = undefined;
	
	update = undefined;
	
	if yui_is_binding(binding) {
		self.binding = binding;
		update = YuiBindableValue__initValue;
		is_live = true;
	}
	else {
		self.binding = undefined;
		self.raw_value = binding;
		self.value = raw_value;
		update = YuiBindableValue__updateRawValue;
	}
	
	static beginAnimation = function(animation) {
		prev_animation = self.animation;
		prev_animation_start_time = animation_start_time;
		prev_animation_start_value = animation_start_value;
		
		is_live = true;
		self.animation = animation;
		animation_start_time = current_time;
		animation_start_value = value;
		animation_step = 0;
		
		if animation.has_effect
			animation_state = {};
	}
}

// TODO support animation for bound values!

// gets the initial value and then swaps over to the updateBinding function
function YuiBindableValue__initValue(data, args = undefined) {
	value = args != undefined && yui_is_call(binding)
		? binding.call(data, args)
		: binding.resolve(data);
		
	bound_value = value;
	update = YuiBindableValue__updateBinding;
	return true;
}

function YuiBindableValue__updateBinding(data, args = undefined) {
	var new_value = args != undefined && yui_is_call(binding)
		? binding.call(data, args)
		: binding.resolve(data);
	
	// check if we need to start a default animation
	if default_anim {
		if new_value != bound_value {
			// binding updated, so track new bound_value and start animation
			bound_value = new_value
			default_anim.init(data, value, new_value);
			beginAnimation(default_anim);
		}
	}
	
	if animation && animation.enabled {
		return YuiBindableValue__runAnimation(bound_value, true); // remains live on animation completion
	}
	else {
		// no default anim so compare directly to value
		if new_value != value {
			value = new_value;
			return true;
		}
		else {
			return false;
		}
	}
}

function YuiBindableValue__updateRawValue(data) {
	
	if animation && animation.enabled {
		return YuiBindableValue__runAnimation(raw_value);
	}
	
	return false; // value is static
}

// NOTE: base_value is the value that would be returned without an animation active
// which is bound_value when there is a binding and raw_value when there isn't
function YuiBindableValue__runAnimation(base_value, default_live_state = false) {
	// calculate the current position along the curve based on start time
	var time = max(current_time - animation_start_time - animation.delay, 0);
	var period_time = animation.continuous ? (time mod animation.duration) : time;
	var curve_pos = period_time / animation.duration;
		
	if animation.step {
		var step = period_time div animation.step;
		if step == animation_step return false;
		animation_step = step;
	}

	var anim_value = animation.compute(
		curve_pos,
		base_value,
		animation_start_value,
		animation_start_time,
		animation_state);
		
	// clear animation when complete
	if animation.isComplete(animation_start_time) {
		is_live = default_live_state;
		animation = undefined;
		animation_start_time = undefined;
		animation_start_value = undefined;
		animation_step = undefined;
		animation_state = undefined;
	}
		
	// TODO lerp between anim_value and prev animation value?
		
	var changed = anim_value != value;
	value = anim_value;
	return changed;
}