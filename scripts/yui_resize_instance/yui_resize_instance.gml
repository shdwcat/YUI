/// @desc  resizes an instance to the specified width and height
/// @param {real} width
/// @param {real} height
function yui_resize_instance(width, height) {
	
	is_size_changed =
		draw_size.x != x
		|| draw_size.y != y
		|| draw_size.w != width
		|| draw_size.h != height;
		
	if is_size_changed {
		draw_size.x = x;
		draw_size.y = y;
		draw_size.w = width;
		draw_size.h = height;
		
		if sprite_index >= 0 {
			image_xscale = width / sprite_get_width(sprite_index);
			image_yscale = height / sprite_get_height(sprite_index);
		}
		else {
			image_xscale = 1;
			image_yscale = 1;
		}
		
		if viewport_size {
			updateViewport();
		}
	}
}