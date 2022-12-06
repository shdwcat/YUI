enum YUI_ANIMATION_BLEND_MODE {
	MULTIPLY,
	ADD,
}
	

/// @description here
function YuiAnimatedValue(bindable_value, animation_props) constructor {
	
	static mode_map = {
		multiply: YUI_ANIMATION_BLEND_MODE.MULTIPLY,
		add: YUI_ANIMATION_BLEND_MODE.ADD,
	};
	
	self._time = undefined;
	self.bindable_value = bindable_value;
	
	self.animation_type = animation_props.type;
	
	if animation_type == "curve" {
		curve = asset_get_index(animation_props.curve);

		value_channel = animcurve_get_channel(curve, "value") 
		if value_channel == -1 {
			value_channel = animcurve_get_channel(curve, "curve1")
		};
		
		period = animation_props.period;
		scale = animation_props[$"scale"] ?? 1;
		continuous = animation_props[$"repeat"] ?? false;
		blend_mode = mode_map[$ animation_props[$"blend_mode"] ?? "multiply"];
	}
	
	static update = function(data, time) {
		bindable_value.update(data);
		var period_time = continuous ? (time mod period) : time;
		var pos = period_time / period;
		var curve_value = animcurve_channel_evaluate(value_channel, pos);
		
		// assume the curve_value is normalized...
		var scaled_value = curve_value * scale;
		
		if _time != time && scaled_value != 1 {
			//yui_log("animation value at time", time, "is", scaled_value);
			_time = time;
		}
		
		
		switch blend_mode {
			case YUI_ANIMATION_BLEND_MODE.MULTIPLY:
				value = bindable_value.value * scaled_value;
				break;
			case YUI_ANIMATION_BLEND_MODE.ADD:
				value = bindable_value.value + scaled_value;
				break;
		}
		return true;
	}
}