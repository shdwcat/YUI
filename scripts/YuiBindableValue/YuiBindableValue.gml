/// @description wraps a YuiExpr to store the value and check for changes
function YuiBindableValue(binding) constructor {
	
	self.animation = undefined;
	self.animation_start_time = undefined;
	self.prev_animation = undefined;
	self.prev_animation_start_time = undefined;
	
	update = undefined;
	
	if yui_is_binding(binding) {
		self.binding = binding;
		update = YuiBindableValue__initValue;
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
		
		self.animation = animation;
		animation_start_time = current_time;
	}
}

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
	
	if animation {
		var anim_value = animation.compute(raw_value, animation_start_time);
		
		// clear animation when complete
		if animation.isComplete(animation_start_time) {
			animation = undefined;
		}
		
		// TODO lerp between anim_value and prev animation value
		
		var changed = anim_value != value;
		value = anim_value;
		return changed;
	}
	
	return false; // value is static
}