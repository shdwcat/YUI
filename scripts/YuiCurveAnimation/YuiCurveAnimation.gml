/// @description here
function YuiCurveAnimation(props, resources, slot_values)
	: YuiAnimationBase(props, resources, slot_values) constructor {

	default_props = {
		type: "curve",
		curve: undefined,
		channel: "value",
		from: undefined,
		to: 1,
		
		effect: undefined, // function to compute the effect result
		effect_interval: undefined, // milliseconds between effect updates
	}
	
	// store for diagnostics
	self.props = props;
	
	curve = yui_bind_and_resolve(props.curve, resources, slot_values);
	if is_string(curve) {
		var curve_asset = asset_get_index(curve);
		if curve_asset == -1 {
			throw yui_error("could not find find animation curve with name:", curve);
		}
		curve = curve_asset;
	}

	channel_name_or_index = yui_bind_and_resolve(props[$"channel"], resources, slot_values) ?? 0;
	value_channel = animcurve_get_channel(curve, channel_name_or_index) 
		
	from = yui_bind_and_resolve(props[$"from"], resources, slot_values);
	to = yui_bind_and_resolve(props[$"to"], resources, slot_values) ?? 1;
	
	var effect = props[$"effect"]
	if effect != undefined {
		// can't use start_value because the target may not be a number
		from ??= 0;
		
		self.effect = yui_bind(effect, resources, slot_values);
		if !yui_is_call(self.effect) {
			throw yui_error("curve effect must be a callable function (script, runtime function, or lambda function)");
		}
		
		self.compute = compute_effect;
	}

	static compute = function(curve_pos, raw_value, start_value, start_time) {
		
		var curve_value = animcurve_channel_evaluate(value_channel, curve_pos);
				
		// lerp the curve value along the start/stop range
		var value = lerp(from ?? start_value, to, curve_value);
		
		return value;
	}
	
	static isComplete = function(start_time) {
		return !continuous
			&& current_time - start_time - delay > duration;
	}
	
	static compute_effect = function(raw_value, start_value, start_time) {
		var curve_value = compute(raw_value, start_value, start_time);
		var effect_value = effect.call(/* no data */, [raw_value, curve_value]);
		return effect_value;
	}
}