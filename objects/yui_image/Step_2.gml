/// @description



// Inherit the parent event
event_inherited();

image_alpha = opacity ?? draw_get_alpha();

frame_value.update(data_source);
var frame = frame_value.value;
if frame != undefined {
	image_index = frame_value.value;
	image_speed = 0;
}

angle_value.update(data_source);
image_angle = angle_value.value;
