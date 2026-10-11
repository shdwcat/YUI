/// @description background and border

if trace
	mx_break()

// check live bg
// TODO: track hover/focused/etc in a ui_state struct rather than pass the element directly
if background_value.update(data_source, self) || !background_initalized {
	background_initalized = true;

	var bg = background_value.value;
	if is_handle(bg) {
		bg_sprite = bg;
		bg_color = undefined;
		bg_alpha = 1;
		
		// TODO probably should check if the sprite is nine-sliced before applying the
		// ui scaling down where it's drawn
	}
	else if bg != undefined {
		bg_sprite = undefined;
		bg_color = is_string(bg)
			? yui_resolve_color(bg)
			: bg;
		bg_alpha = ((bg_color & 0xFF000000) >> 24) / 255; // extract alpha
	}
	else {
		// no background at all so clear it
		bg_sprite = undefined;
		bg_color = undefined;
		bg_alpha = 0;
	}
}

var scissor = undefined;
if viewport_size {
	if !viewport_part.visible {
		// viewport part is not visible so nothing to draw
		exit;
	}
	
	if viewport_part.clipped {
		var scissor = gpu_get_scissor();
		gpu_set_scissor(
			(viewport_part.x + xoffset) * ui_scale,
			(viewport_part.y + yoffset) * ui_scale,
			viewport_part.w * ui_scale,
			viewport_part.h * ui_scale);
	}
}

// draw background
if bg_alpha > 0 {
	
	if bg_sprite != undefined {
		// use 9slicing
		
		if apply_sprite_scaling and ui_scale != 1 {
			// use matrix to get the 9slice background to upscale correctly for scaled UI
			var matrix = matrix_build(x,y,depth,0,0,0,1/ui_scale,1/ui_scale,1);
			matrix_set(matrix_world,matrix);

			draw_sprite_stretched_ext(
				bg_sprite, 0,
				0, 0,
				draw_size.w * ui_scale, draw_size.h * ui_scale,
				active_bg_blend_color, bg_alpha * opacity);

			matrix_set(matrix_world,matrix_build_identity())
		}
		else
		{
			draw_sprite_stretched_ext(
				bg_sprite, 0,
				x, y,
				draw_size.w, draw_size.h,
				active_bg_blend_color, bg_alpha * opacity);
		}
	}
	
	else if bg_color != undefined {
		draw_sprite_ext(
			yui_white_pixel, 0,
			x, y, draw_size.w, draw_size.h,
			0, bg_color, bg_alpha * opacity);
	}
}

// draw border
if draw_border {
	var do_border_draw = false;
	
	if focused && has_focus_color {
		var do_border_draw = true;
		var color = border_focus_color;
		var alpha = 1;
	}
	else if !focused && has_border_color {
		var do_border_draw = true;
		var color = border_color;
		var alpha = border_alpha;
	}
	
	if do_border_draw {
		yui_draw_rect_outline(
			x, y, draw_size.w, draw_size.h,
			border_thickness, color, alpha * opacity);
	}
}

if scissor != undefined {
	gpu_set_scissor(scissor);
}