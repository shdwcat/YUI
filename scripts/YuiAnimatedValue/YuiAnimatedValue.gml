/// @description here
function YuiAnimatedValue(bindable_value, animation_props) constructor {
	self.bindable_value = bindable_value;
	
	self.animation_type = animation_props.type;
	
	if animation_type == "curve" {
		curve = asset_get_index(animation_props.curve);
		value_channel = animcurve_get_channel(curve, "value");
		period = animation_props.period;
	}
	
	static update = function(data, time) {
		bindable_value.update(data);
		var period_time = (time mod period);
		var pos = period_time / period;
		var curve_value = animcurve_channel_evaluate(value_channel, pos);
		
		// assume the curve_value is normalized...
		value = curve_value * bindable_value.value;
		return true;
	}
}