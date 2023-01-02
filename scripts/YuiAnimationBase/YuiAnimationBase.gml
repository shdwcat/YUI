/// @description here
function YuiAnimationBase(props, resources, slot_values) constructor {

	enabled = yui_bind_and_resolve(props[$"enabled"], resources, slot_values) ?? true;
	duration = yui_bind_and_resolve(props[$"duration"], resources, slot_values) ?? 1000; // TODO error on zero or negative duration
	delay = yui_bind_and_resolve(props[$"delay"], resources, slot_values) ?? 0; // TODO error on negative delay
	continuous = yui_bind_and_resolve(props[$"repeat"], resources, slot_values) ?? false;
}