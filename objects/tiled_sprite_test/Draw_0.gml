/// @description draw tiled sprite

yui_draw_sprite_tiled(sprite_index, 0, x, y, width, height, c_white, 1, 1);
//fooo(sprite_index, 0, x, y, width, height, c_white, 1, 1);

// draw rect to show target area
draw_rectangle_color(x, y, x + width, y + height, c_red, c_red, c_red, c_red, true);
