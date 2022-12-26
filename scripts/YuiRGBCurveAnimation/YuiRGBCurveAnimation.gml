/// @description here
function YuiRGBCurveAnimation(props, resources, slot_values) constructor {
	
	static default_props = {
		type: "rgb_curve",
		curve: undefined,
		channel: 0,
		from: undefined,
		to: undefined,
		duration: 1000,
		"repeat": false,
		enabled: true,
		delay: 0, // milliseconds
	}
	
	// store for diagnostics
	self.props = props;
	
	curve = yui_bind_and_resolve(props.curve, resources, slot_values);
	if is_string(curve)
		curve = asset_get_index(curve);
		
	channel_name_or_index = yui_bind_and_resolve(props[$"channel"], resources, slot_values) ?? 0;
	value_channel = animcurve_get_channel(curve, channel_name_or_index) 
	
	enabled = yui_bind_and_resolve(props[$"enabled"], resources, slot_values) ?? true;
		
	duration = yui_bind_and_resolve(props[$"duration"], resources, slot_values) ?? 1000; // TODO error on zero or negative duration
	continuous = yui_bind_and_resolve(props[$"repeat"], resources, slot_values) ?? false;
	delay = yui_bind_and_resolve(props[$"delay"], resources, slot_values) ?? 0;
	
	from = yui_bind_and_resolve(props[$"from"], resources, slot_values);
	if from != undefined {
		var color = yui_resolve_color(from);
		red_start = color_get_red(color);
		green_start = color_get_green(color);
		blue_start = color_get_blue(color);
	}
	else {
		red_start = undefined;
		green_start = undefined;
		blue_start = undefined;
	}
	
	to = yui_bind_and_resolve(props[$"to"], resources, slot_values);
	if to != undefined {
		var color = yui_resolve_color(to);
		red_stop = color_get_red(color);
		green_stop = color_get_green(color);
		blue_stop = color_get_blue(color);
	}
	else {
		red_stop = undefined;
		green_stop = undefined;
		blue_stop = undefined;
	}

	static compute = function(raw_color, start_value, start_time) {
				
		// calculate the current position along the curve based on start time
		var time = max(current_time - start_time - delay, 0);
		var period_time = continuous ? (time mod duration) : time;
		var pos = period_time / duration;
		
		var curve_value = animcurve_channel_evaluate(value_channel, pos);
		
		// default behavior when from/to aren't present is to lerp from the previous value to the raw color
		var lerp_r = lerp(red_start ?? color_get_red(start_value), red_stop ?? color_get_red(raw_color), curve_value);
		var lerp_g = lerp(green_start ?? color_get_green(start_value), green_stop ?? color_get_green(raw_color), curve_value);
		var lerp_b = lerp(blue_start ?? color_get_blue(start_value), blue_stop ?? color_get_blue(raw_color), curve_value);
		
		var color = make_color_rgb(lerp_r, lerp_g, lerp_b);
		
		return color;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
}