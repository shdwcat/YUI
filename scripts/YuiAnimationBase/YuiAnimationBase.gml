/// @description here
function YuiAnimationBase(props, resources, slot_values) constructor {
	
	//modes = yui_enum([
	//	"once",
	//	"repeat",
	//	"bounce",
	//	"patrol",
	//]);
	
	has_effect = false;

	trace = yui_bind_and_resolve(props[$"trace"], resources, slot_values) ?? false;
		
	bindings = {
		enabled: yui_bind(props[$"enabled"], resources, slot_values),
		continuous: yui_bind(props[$"repeat"], resources, slot_values),
		duration: yui_bind(props[$"duration"], resources, slot_values),
		delay: yui_bind(props[$"delay"], resources, slot_values),
		step: yui_bind(props[$"step"], resources, slot_values),
	}
	
	// rename to bind?
	static init = function(data) {
		enabled = yui_resolve_binding(bindings.enabled, data) ?? true;
		continuous = yui_resolve_binding(bindings.continuous, data) ?? false;
		
		 // TODO error on zero or negative duration
		duration = yui_resolve_binding(bindings.duration, data) ?? 1000;
		
		// TODO error on negative delay
		delay = yui_resolve_binding(bindings.delay, data) ?? 0;
		
		step = yui_resolve_binding(bindings.step, data);
	}
}