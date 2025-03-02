/// @description align relative to room game object
function yui_align_relative(item, alignment_h, alignment_v) {
	var target_x = x;
	var target_y = y;

	switch alignment_h {
		case fa_left:
			target_x = item.bbox_left - draw_size.w;
			break;
		case fa_right:
			target_x = item.bbox_right;
			break;
		case fa_center:
			target_x = item.x - (draw_size.w / 2);
			break;
	}
	
	switch alignment_v {
		case fa_top:
			target_y = item.bbox_top - draw_size.h;
			break;
		case fa_bottom:
			target_y = item.bbox_bottom;
			break;
		case fa_middle:
			target_y = item.y - (draw_size.h / 2);
			break;
	}
	
	// convert to gui space
	var gui_x = yui_world_to_gui_x_2(target_x);
	var gui_y = yui_world_to_gui_y_2(target_y);
	
	// position ourselves at the target
	draw_size.x = floor(gui_x);
	draw_size.y = floor(gui_y);
}