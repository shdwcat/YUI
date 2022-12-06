/// @description here
function YuiAnimatedValue(bindable_value, animation_props) constructor {
		
	self._time = undefined;
	self.value = undefined;
	self.bindable_value = bindable_value;
	
	self.animation_type = animation_props.type;
	
	if animation_type == "curve" {
		curve = asset_get_index(animation_props.curve);

		value_channel = animcurve_get_channel(curve, "value") 
		if value_channel == -1 {
			value_channel = animcurve_get_channel(curve, "curve1")
		};
		
		period = animation_props.period;
		continuous = animation_props[$"repeat"] ?? false;
		start = animation_props[$"start"] ?? 0;
		stop = animation_props[$"end"] ?? 1;
	}
	
	static update = function(data, time) {
		bindable_value.update(data);
		var period_time = continuous ? (time mod period) : time;
		var pos = period_time / period;
		var curve_value = animcurve_channel_evaluate(value_channel, pos);
		
		// assume the curve_value is normalized...
		var newValue = lerp(start, stop, curve_value);
		
		var changed = newValue != value;
		value = newValue;
		
		if _time != time && value != 1 {
			//yui_log("animation value at time", time, "is", value);
			_time = time;
		}
		
		return changed;
	}
}