/// @description here
function YuiCurveAnimation(props, resources, slot_values) constructor {
	default_props = {
		type: "curve",
		curve: undefined,
		channel: "value",
		start: 0,
		"end": 1,
		"repeat": false,
		duration: 1000, // 1000 milliseconds = 1 second
		delay: 0, // milliseconds
	}
	
	// store for diagnostics
	self.props = props;
	
	curve = yui_bind_and_resolve(props.curve, resources, slot_values);
	if is_string(curve)
		curve = asset_get_index(curve);
	
	enabled = yui_bind_and_resolve(props[$"enabled"], resources, slot_values) ?? true;
	channel_name_or_index = yui_bind_and_resolve(props[$"channel"], resources, slot_values) ?? 0;

	value_channel = animcurve_get_channel(curve, channel_name_or_index) 
		
	duration = yui_bind_and_resolve(props[$"duration"], resources, slot_values) ?? 1000; // TODO error on zero or negative duration
	delay = yui_bind_and_resolve(props[$"delay"], resources, slot_values) ?? 0; // TODO error on negative delay
	start = yui_bind_and_resolve(props[$"start"], resources, slot_values) ?? 0;
	stop = yui_bind_and_resolve(props[$"end"], resources, slot_values) ?? 1;
	continuous = yui_bind_and_resolve(props[$"repeat"], resources, slot_values) ?? false;

	static compute = function(raw_value, start_time) {
		
		// calculate the current position along the curve based on start time
		var time = max(current_time - start_time - delay, 0);
		var period_time = continuous ? (time mod duration) : time;
		var pos = period_time / duration;
		
		var curve_value = animcurve_channel_evaluate(value_channel, pos);
				
		// lerp the curve value along the start/stop range
		var value = lerp(start, stop, curve_value);
		
		return value;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
}