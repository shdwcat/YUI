/// @description restores the value to its base value
function YuiResetValueAnimation(props, resources, slot_values)
	: YuiAnimationBase(props, resources, slot_values) constructor {

	default_props = {
		type: "reset_value",
	}
	
	// store for diagnostics
	self.props = props;
	
	static base_init = init;
	static init = function(data, _from = 0, _to = 1) {
		base_init(data);
	}

	static compute = function(curve_pos, base_value, start_value, start_time) {
		return base_value;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
}