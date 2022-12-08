/// @description here
function YuiColorCurveAnimation(props, resources, slot_values) constructor {
	
	// store for diagnostics
	self.props = props;
	
	enabled = props[$"enabled"] ?? true;
		
	duration = props[$"duration"] ?? 1000; // TODO error on zero or negative duration
	continuous = props[$"repeat"] ?? false;
	
	red_start = (props[$"red_start"] ?? props[$"start"]);
	red_stop = props[$"red_end"] ?? props[$"end"];
	
	green_start = (props[$"green_start"] ?? props[$"start"]);
	green_stop = props[$"green_end"] ?? props[$"end"];
	
	blue_start = (props[$"blue_start"] ?? props[$"start"]);
	blue_stop = props[$"blue_end"] ?? props[$"end"];
	
	// one curve to drive RGB
	var curve_id = props[$"curve"];
	curve = curve_id != undefined ? asset_get_index(curve_id) : undefined;
	if curve {
		// single curve with either rgb color channels OR one channel to drive rgb together
		var curve_struct = animcurve_get(curve);
		var channel_count = array_length(curve_struct.channels);
		
		if channel_count >= 3 {
			var red_channel_id = props[$"red_channel"] ?? 0;
			var green_channel_id = props[$"green_channel"] ?? 1;
			var blue_channel_id = props[$"blue_channel"] ?? 2;
			// TODO alpha channel?
		}
		else {
			var red_channel_id = props[$"red_channel"] ?? 0;
			var green_channel_id = props[$"green_channel"] ?? 0;
			var blue_channel_id = props[$"blue_channel"] ?? 0;
		}
		
		red_channel = animcurve_get_channel(curve, red_channel_id);
		green_channel = animcurve_get_channel(curve, green_channel_id);
		blue_channel = animcurve_get_channel(curve, blue_channel_id);
	}
	else {
		// alternately can specify curves per channel
		var red_curve_id = props[$"red_curve"];
		red_curve = red_curve_id != undefined ? asset_get_index(red_curve_id) : undefined;
		var green_curve_id = props[$"green_curve"];
		green_curve = green_curve_id != undefined ? asset_get_index(green_curve_id) : undefined;
		var blue_curve_id = props[$"blue_curve"];
		blue_curve = blue_curve_id != undefined ? asset_get_index(blue_curve_id) : undefined;
		
		// assume the curves exist and that we should use the first channel
		red_channel = animcurve_get_channel(red_curve, 0);
		green_channel = animcurve_get_channel(green_curve, 0);
		blue_channel = animcurve_get_channel(blue_curve, 0);
	}

	static compute = function(raw_color, start_time) {
		
		// current color animation logic is very weird and seems non-intuitive
		// perhaps the animation specifies the target color and
		// the logic then just applies curve(s) to the rgb to go
		// from the raw_color to the target?
		// that seems to match what I would want to do, e.g,
		// animate a color from gray to pink when an item is focused etc
				
		// calculate the current position along the curve based on start time
		var time = current_time - start_time;
		var period_time = continuous ? (time mod duration) : time;
		var pos = period_time / duration;
		
		var curve_r = animcurve_channel_evaluate(red_channel, pos);
		var curve_g = animcurve_channel_evaluate(green_channel, pos);
		var curve_b = animcurve_channel_evaluate(blue_channel, pos);
		
		// default behavior when start/stop aren't present is to lerp from black to the raw color
		var lerp_r = lerp(red_start ?? color_get_red(raw_color), red_stop ?? color_get_red(raw_color), curve_r);
		var lerp_g = lerp(green_start ?? color_get_green(raw_color), green_stop ?? color_get_green(raw_color), curve_g);
		var lerp_b = lerp(blue_start ?? color_get_blue(raw_color), blue_stop ?? color_get_blue(raw_color), curve_b);
		
		var color = make_color_rgb(lerp_r, lerp_g, lerp_b);
		
		return color;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time > duration;
	}
}