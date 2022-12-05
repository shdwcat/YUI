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
	
	self.bindable_value = bindable_value;
	
	self.animation_type = animation_props.type;
	
	if animation_type == "curve" {
		curve = asset_get_index(animation_props.curve);
		value_channel = animcurve_get_channel(curve, "value");
		period = animation_props.period;
		scale = animation_props[$"scale"] ?? 1;
		blend_mode = mode_map[$ animation_props[$"blend_mode"] ?? "multiply"];
	}
	
	static update = function(data, time) {
		bindable_value.update(data);
		var period_time = (time mod period);
		var pos = period_time / period;
		var curve_value = animcurve_channel_evaluate(value_channel, pos);
		
		// assume the curve_value is normalized...
		var scaled_value = curve_value * scale;
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