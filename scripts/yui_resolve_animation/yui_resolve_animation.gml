/// @description here
function yui_resolve_animation(anim_props, resources, slot_values) {
	if is_array(anim_props) {
		var sequence = new YuiAnimationSequence(anim_props);
		return sequence;
	}
	else if is_struct(anim_props) {
		if anim_props.type == "curve" {
			var anim = new YuiCurveAnimation(anim_props, resources, slot_values);
			return anim;
		}
		else if anim_props.type == "color_curve" {
			var anim = new YuiColorCurveAnimation(anim_props, resources, slot_values);
			return anim;
		}
		else if anim_props.type == "hsv_curve" {
			var anim = new YuiHSVCurveAnimation(anim_props, resources, slot_values);
			return anim;
		}
		else if yui_is_binding(anim_props) {
			throw yui_error("data binding animation values is not supported", anim_props.type);
		}
		else {
			throw yui_error("unknown animation type", anim_props.type);
		}
	}
	else if is_string(anim_props) {
		// a string will either be a binding expression or a curve name
		if yui_is_binding_expr(anim_props) {
			var resolved_anim_props = yui_bind(anim_props, resources, slot_values);
			
			// if the result is not a binding, copy the resolved values to ensure we're not sharing state incorrectly
			if !yui_is_binding(resolved_anim_props)
			&& (is_struct(resolved_anim_props) || is_array(resolved_anim_props)) {
				resolved_anim_props = yui_deep_copy(resolved_anim_props)
			}
			
			// The result might be something like a slot or resource, or 'raw' anim props.
			// In any of those cases, this recursive call will resolve that value correctly.
			return yui_resolve_animation(resolved_anim_props, resources, slot_values);
		}
		else {
			var curve_props =  {
				type: "curve",
				curve: anim_props,
			};
			var anim = new YuiCurveAnimation(curve_props, resources, slot_values);
			return anim;
		}
	}
	else {		
		throw yui_error("unsupported animation value:", anim_props);
	}
}