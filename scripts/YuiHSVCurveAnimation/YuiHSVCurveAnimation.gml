/// @description here
function YuiHSVCurveAnimation(props, resources, slot_values)
	: YuiAnimationBase(props, resources, slot_values) constructor {
	
	static default_props = {
		type: "hsv_curve",
		curve: undefined,
		channel: 0,
		from: undefined,
		to: undefined,
	}
	
	// store for diagnostics
	self.props = props;
	
	curve = yui_bind_and_resolve(props.curve, resources, slot_values);
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
		h_start = color_get_hue(color);
		s_start = color_get_saturation(color);
		v_start = color_get_value(color);
	}
	else {
		h_start = undefined;
		s_start = undefined;
		v_start = undefined;
	}
	
	to = yui_bind_and_resolve(props[$"to"], resources, slot_values);
	if to != undefined {
		var color = yui_resolve_color(to);
		h_stop = color_get_hue(color);
		s_stop = color_get_saturation(color);
		v_stop = color_get_value(color);
	}
	else {
		h_stop = undefined;
		s_stop = undefined;
		v_stop = undefined;
	}

	static compute = function(curve_pos, raw_color, start_value, start_time) {
		
		var curve_value = animcurve_channel_evaluate(value_channel, curve_pos);
		
		// default behavior when from/to aren't present is to lerp from the previous value to the raw color
		var h1 = h_start ?? color_get_hue(start_value);
		var s1 = s_start ?? color_get_saturation(start_value);
		var v1 = v_start ?? color_get_value(start_value);
		
		var h2 = h_stop ?? color_get_hue(raw_color);
		var s2 = s_stop ?? color_get_saturation(raw_color);
		var v2 = v_stop ?? color_get_value(raw_color)
		
		// see https://stackoverflow.com/a/56367615 for HSV lerp logic
		
		// if either color is black, don't lerp hue or saturation
		if v1 = 0 {
			var lerp_h = h2;
			var lerp_s = s2;
		}
		else if v2 == 0 {
			var lerp_h = h1;
			var lerp_s = s1;
		}
		else {
			// if either color is grey, don't lerp hue
			if s1 == 0 {
				var lerp_h = s2;
			}
			else if s2 == 0 {
				var lerp_h = s1;
			}
			else {
				// radial hue lerp
				var diff = h2 - h1;
				
				// check if we need to lerp in the shorter direction
				if diff > 128 {
					// e.g. if h1 is 5 and h2 is 192, lerp from 260 (5+255) to 192 then modulo by 255
					var lerp_h = lerp(h1 + 255, h2, curve_value) % 255;
				}
				else if diff < -128 {
					// e.g. if h1 is 192 and h2 is 5, lerp from 192 to 260 (5+255) then modulo by 255
					var lerp_h = lerp(h1, h2 + 255, curve_value) % 255;
				}
				else {
					var lerp_h = lerp(h1, h2, curve_value);
				}
			}
			
			var lerp_s = lerp(s1, s2, curve_value);
		}
		
		var lerp_v = lerp(v1, v2, curve_value);
		
		var color = make_color_hsv(lerp_h, lerp_s, lerp_v);
		
		return color;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
}