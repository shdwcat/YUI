/// @description applies alignment to a drawn item within its draw_rect
function yui_align_item(item, alignment) {
	var xoffset = 0;
	var yoffset = 0;
	
	// todo: right + bottom + stretch
	switch alignment.h {
		case fa_right:
			xoffset = item.draw_rect.w - item.draw_size.w;
			break;
		case fa_center:
			xoffset = item.parent.draw_size.x - item.x - item.draw_size.w / 2;
			break;
	}
	
	switch alignment.v {
		case fa_bottom:
			yoffset = item.draw_rect.h - item.draw_size.h;
			break;
		case fa_middle:
			yoffset = (item.draw_rect.h - item.draw_size.h) / 2;
			break;
	}
	
	item.move(floor(xoffset), floor(yoffset));
}