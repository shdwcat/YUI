/// @description draw text/scribble element

//if trace {
//	DEBUG_BREAK_YUI;
//}

// draw background
if bg_alpha > 0 {
	draw_sprite_stretched_ext(
		yui_white_pixel, 0, 
		x, y, draw_size.w, draw_size.h,
		bg_color, bg_alpha * opacity);
}

if use_scribble {
	if highlight && highlight_color != undefined {
		scribble_element.blend(highlight_color, opacity);
	}
	else {	
		scribble_element.blend(text_color, opacity);
	}

	// draw the scribble element
	scribble_element.draw(x + element_xoffset, y + element_yoffset, typist);
}
else {
	var color = text_color ?? c_white;
	if highlight && highlight_color != undefined {
		color = highlight_color;
	}

	var old_font = draw_get_font();
	var old_halign = draw_get_halign();
	var old_valign = draw_get_valign();
	
	draw_set_font(font);
	draw_set_halign(layout_props.halign);
	draw_set_valign(layout_props.valign);
	
	draw_text_ext_color(
		x + element_xoffset, y + element_yoffset,
		bound_values.text, -1, text_width,
		color, color, color, color, opacity);
		
	draw_set_font(old_font);
	draw_set_halign(old_halign);
	draw_set_valign(old_valign);
}


if (trace) {
	yui_draw_trace_rect(trace, padded_rect, c_yellow);

	yui_draw_trace_rect(trace, draw_size, c_fuchsia);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(trace, draw_size, c_lime);
	}
}