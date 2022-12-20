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
	
	enabled = props[$"enabled"] ?? true;
	curve = asset_get_index(props.curve);
	channel_name_or_index = props[$"channel"] ?? 0;

	value_channel = animcurve_get_channel(curve, channel_name_or_index) 
		
	duration = props[$"duration"] ?? 1000; // TODO error on zero or negative duration
	delay = props[$"delay"] ?? 0; // TODO error on negative delay
	start = props[$"start"] ?? 0;
	stop = props[$"end"] ?? 1;
	continuous = props[$"repeat"] ?? false;

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