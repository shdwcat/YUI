/// @description wraps a YuiExpr to store the value and check for changes
function YuiBindableValue(binding) constructor {
	
	is_live = false;
		
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
function YuiBindableValue__initValue(data) {
	value = binding.resolve(data);
	update = YuiBindableValue__updateBinding;
	return true;
}

function YuiBindableValue__updateBinding(data) {
	var newValue = binding.resolve(data);
	if newValue != value {
		value = newValue;
		return true;
	}
	else {
		return false;
	}
}
	
function YuiBindableValue__updateRawValue(data) {
	
	if animation && animation.enabled {
		
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
			raw_value,
			animation_start_value,
			animation_start_time,
			animation_state);
		
		// clear animation when complete
		if animation.isComplete(animation_start_time) {
			is_live = false;
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
	
	return false; // value is static
}