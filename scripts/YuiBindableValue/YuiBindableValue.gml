/// @description wraps a YuiExpr to store the value and check for changes
function YuiBindableValue(binding) constructor {
	
	update = undefined;
	
	if yui_is_binding(binding) {
		self.binding = binding;
		self.hasValue = false;
		update = YuiBindableValue__initValue;
	}
	else {
		self.binding = undefined;
		self.value = binding;
		update = YuiBindableValue__updateRawValue;
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
	return false; // value is static
}