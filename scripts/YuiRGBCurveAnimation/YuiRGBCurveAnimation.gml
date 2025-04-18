/// @description here
function YuiRGBCurveAnimation(props, resources, slot_values)
	: YuiAnimationBase(props, resources, slot_values) constructor {
	
	static default_props = {
		type: "rgb_curve",
		curve: yui_linear_curve,
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
	
	self.trace = props[$ "trace"];
	
	curve = yui_bind_and_resolve(props[$ "curve"], resources, slot_values) ?? yui_linear_curve;
	if is_string(curve) {
		var curve_asset = asset_get_index(curve);
		if curve_asset == -1 {
			throw yui_error("could not find animation curve with name:", curve);
		}
		curve = curve_asset;
	}
	else if curve == undefined {
		throw yui_error("could not find animation curve for:", props.curve);
	}
		
	channel_name_or_index = yui_bind_and_resolve(props[$"channel"], resources, slot_values) ?? 0;
	value_channel = animcurve_get_channel(curve, channel_name_or_index) 
	
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

	static compute = function(curve_pos, base_color, start_value, start_time) {
		
		var curve_value = animcurve_channel_evaluate(value_channel, curve_pos);
		
		// default behavior when from/to aren't present is to lerp from the previous value to the raw color
		var lerp_r = lerp(red_start ?? color_get_red(start_value), red_stop ?? color_get_red(base_color), curve_value);
		var lerp_g = lerp(green_start ?? color_get_green(start_value), green_stop ?? color_get_green(base_color), curve_value);
		var lerp_b = lerp(blue_start ?? color_get_blue(start_value), blue_stop ?? color_get_blue(base_color), curve_value);
		
		var color = make_color_rgb(lerp_r, lerp_g, lerp_b);
		
		if trace
			yui_log($"rgb: {lerp_r} {lerp_g} {lerp_b}: {yui_color_to_hex(color)}");
		
		// set alpha to 1 (no alpha channel animation yet)
		return color| $FF000000;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
}