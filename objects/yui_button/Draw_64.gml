/// @description draw border + highlight

// Inherit the parent event
event_inherited();

var show_highlight = highlight && highlight_color != undefined;
if show_highlight {
	var alpha = button_pressed ? pressed_alpha : highlight_alpha;
	if alpha > 0 {	
		var old_alpha = draw_get_alpha();
		draw_set_alpha(alpha);
		draw_rectangle_color(
			draw_size.x, draw_size.y,
			draw_size.x + draw_size.w - 1, draw_size.y + draw_size.h - 1,
			highlight_color, highlight_color, highlight_color, highlight_color, false);
		draw_set_alpha(old_alpha);
	}
}

//if content_item {
//	// can solve this in the cursor manager hover logic
//	content_item.highlight = highlight;
//}

//button_highlight = false;
button_pressed = false;
