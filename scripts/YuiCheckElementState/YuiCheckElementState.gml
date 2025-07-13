/// @description here
function YuiCheckElementState(props, resources, slot_values) : YuiExpr() constructor {
	static is_call = true;
	
	static default_props = {
		disabled: undefined,
		pressed: undefined,
		hover: undefined,
		focused: undefined,
		normal: undefined,
	}
	
	props = yui_apply_props(props);
	disabled = yui_bind(props.disabled, resources, slot_values);
	pressed = yui_bind(props.pressed, resources, slot_values);
	hover = yui_bind(props.hover, resources, slot_values);
	focused = yui_bind(props.focused, resources, slot_values);
	normal = yui_bind(props.normal, resources, slot_values);
	
	is_disabled_live = yui_is_live_binding(disabled);
	is_pressed_live = yui_is_live_binding(pressed);
	is_hover_live = yui_is_live_binding(hover);
	is_focused_live	= yui_is_live_binding(focused);
	is_normal_live = yui_is_live_binding(normal);
	
	is_yui_live_binding =
		is_disabled_live
		|| is_pressed_live
		|| is_hover_live
		|| is_focused_live
		|| is_normal_live;
	
	static call = function(data, element_state) {
		if element_state == undefined return;
		
		// evaluate states by priority: disabled -> pressed -> hover -> focused -> normal
		// NNOTE: if one state doesn't have a value we still need to check the
		// next since an element can be pressed hovered and focused at the same time
		
		if !element_state.enabled {
			// note: disabled state always overrides any of the others
			if disabled != undefined {
				var result = is_disabled_live ? disabled.resolve(data) : disabled;
				return result;
			}
			else {
				var result = is_normal_live ? normal.resolve(data) : normal;
				return result;
			}
		}
		
		if struct_exists(element_state, "button_pressed") && element_state.button_pressed {
			var result = is_pressed_live ? pressed.resolve(data) : pressed;
			if result != undefined return result;
		}
		
		if element_state.highlight {
			var result = is_hover_live ? hover.resolve(data) : hover;
			if result != undefined return result;
		}
		
		if element_state.focused {
			var result = is_focused_live ? focused.resolve(data) : focused;
			if result != undefined return result;
		}
		
		var result = is_normal_live ? normal.resolve(data) : normal;
		if result != undefined return result;
	}
}