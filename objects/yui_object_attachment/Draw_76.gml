/// @description align to target

if target_value.is_live
	target_value.update(data_source);

var target = target_value.value;	

if target != undefined && instance_exists(target)
	alignToTarget(target);

// Inherit the parent event
event_inherited();