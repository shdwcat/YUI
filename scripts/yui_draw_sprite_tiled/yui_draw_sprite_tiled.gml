/// @description draw a sprite with tiling to fill a rect
/// @arg sprite
/// @arg subimg
/// @arg x
/// @arg y
/// @arg width
/// @arg height
/// @arg color
/// @arg alpha
/// @arg scale applied to the sprite before tiling!
function yui_draw_sprite_tiled(
	sprite,
	subimg,
	x,
	y,
	width,
	height,
	color,
	alpha,
	scale)
	{
	var scaled_spr_width = sprite_get_width(sprite) * scale;
	var scaled_spr_height = sprite_get_height(sprite) * scale;
	var scaled_x_offset = sprite_get_xoffset(sprite) * scale;
	var scaled_y_offset = sprite_get_yoffset(sprite) * scale;
	
	var _x = x;
	var _y = y;
	var x_max = x + width;
	var y_max = y + height;
	
	var part_width = 0;	
	var is_last_row = false;
	
	// draw sprite rows vertically
	for (_y = y; _y < y_max; _y += scaled_spr_height)
	{
		
		// check if this is the last row
		if _y + scaled_spr_height > y_max {
			var part_height = y_max - _y;
			is_last_row = true;
		}
		
		// draw sprites in this row
		for (_x = x; _x < x_max; _x += scaled_spr_width) {
			
			// check if this is the end of the row
			if _x + scaled_spr_width > x_max {
				part_width = x_max - _x;
				var h = is_last_row
					? part_height
					: scaled_spr_height;
				draw_sprite_part_ext(sprite, subimg, 0, 0, part_width, h, _x, _y, scale, scale, color, alpha);
			}
			// otherwise draw at full width
			else {
				if !is_last_row {
					draw_sprite_ext(
						sprite, subimg,
						_x + scaled_x_offset,
						_y + scaled_y_offset,
						scale, scale, 0, color, alpha);
				}
				else {
					// if this is the last row, draw only the upper portion of the sprite
					draw_sprite_part_ext(sprite, subimg, 0, 0, scaled_spr_width, part_height, _x, _y, scale, scale, color, alpha);
				}
			}
		}
	}
	
	return;
}
