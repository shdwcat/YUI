/// @description draw line gui

if !draw_to_world {
	if use_cleanshapes {
		clean_line.Draw();
	}
	else {
		draw_line_width_color(x1, y1, x2, y2, width, color, color_end);
	}
}