/// @description resizes an instance to the specified width and height
function yui_resize_instance(width, height) {
	draw_size.x = x;
	draw_size.y = y;
	draw_size.w = width;
	draw_size.h = height;
	image_xscale = width / sprite_get_width(sprite_index);
	image_yscale = height / sprite_get_height(sprite_index);
}