/// @description gets the x and y scale values to scale one sprite to the given size
/// @arg target_width
/// @arg target_height
/// @arg source_sprite
function yui_get_sprite_scale_transform(argument0, argument1, argument2) {

	var target_width = argument0;
	var target_height = argument1;
	var source_sprite = argument2;

	var x_scale = target_width / sprite_get_width(source_sprite);
	var y_scale = target_height / sprite_get_height(source_sprite);

	return [x_scale, y_scale];

}