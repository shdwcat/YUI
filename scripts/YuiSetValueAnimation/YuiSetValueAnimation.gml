/// @description sets constant value without any computation (useful to change sprite)
function YuiSetValueAnimation(props, resources, slot_values)
	: YuiAnimationBase(props, resources, slot_values) constructor {

	default_props = {
		type: "set_value",
		value: undefined,
	}
	
	// store for diagnostics
	self.props = props;
	
	bindings.value = yui_bind(props.value, resources, slot_values);
	
	static base_init = init;
	static init = function(data, _from = 0, _to = 1) {
		base_init(data);
		value = yui_resolve_binding(bindings.value, data) ?? _from;
	}

	static compute = function(curve_pos, base_value, start_value, start_time) {
		return value;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
}