/// @description Acts like a switch statement for UI, choosing a renderer based on whether a key matches the switch value
function YuiSwitchRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		type: "switch",
		switch_on: undefined, // binding to the switch value
		cases: {}, // struct map of values to case renderers
		default_case: undefined, // renderer when no case matches the switch value
	}
	
	props = init_props_old(_props);
	props.switch_on = yui_bind(props.switch_on, _resources);
	
	// init case renderers
	case_renderers = {}
	var case_keys = variable_struct_get_names(props.cases);
	var i = 0; repeat array_length(case_keys) {
		var case_key = case_keys[i++];
		var yui_data = props.cases[$ case_key];
		var case_renderer = yui_resolve_renderer(yui_data, _resources);
		
		case_renderers[$ case_key] = case_renderer;
	}
	
	if props.default_case != undefined {
		default_renderer = yui_resolve_renderer(props.default_case, _resources);
	}
	else {
		default_renderer = undefined;
	}
	
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
		
		var is_visible = ro_context.resolveBinding(props.visible, data);
		if !is_visible return false;
		
		var switch_value = ro_context.resolveBinding(props.switch_on, data);
		
		var case_renderer = case_renderers[$ string(switch_value)];
		
		// try treating 1/0 as true/false
		if case_renderer == undefined {
			if switch_value == true {
				case_renderer = case_renderers[$ "true"];
			}
			else if switch_value == false {
				case_renderer = case_renderers[$ "false"];
			}
		}
		
		// if still undefined, try default renderer
		if case_renderer == undefined {
			if default_renderer != undefined {
				case_renderer = default_renderer;
			}
			else {
				// if no case_renderer and no default_renderer, don't render
				return false;
			}
		}
		
		var case_result = case_renderer.update(ro_context, data, draw_rect, item_index);
		return case_result;
	}
}