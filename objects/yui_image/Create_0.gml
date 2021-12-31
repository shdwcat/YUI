/// @description 

// Inherit the parent event
event_inherited();

build = function() {
	trace = yui_element.props.trace; // hack
	
	if bound_values.sprite >= 0 {
		sprite_index = bound_values.sprite;
	}
	else {
		visible = false;
	}	
	
	if bound_values.frame != undefined {
		image_index = bound_values.frame;
		image_speed = 0;
	}
	
	image_angle = bound_values.angle;
	image_alpha = bound_values.opacity;	
	blend_color = bound_values.blend_color;
	
	if trace {
		DEBUG_BREAK_YUI;
	}
}

arrange = function(available_size) {
	if !visible {
		if layout_props.size.is_exact_size {
			yui_resize_instance(self, layout_props.size.w, layout_props.size.h);
			return draw_size;
		}
		return;
	};
	
	if trace {
		DEBUG_BREAK_YUI;
	}

	draw_rect = available_size;
	
	var padding = layout_props.padding;	
	padded_rect = yui_apply_padding(available_size, padding, layout_props.size);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w < 0 || padded_rect.h < 0 {
		yui_resize_instance(self, 0, 0);
		return draw_size;
	}
	
	// position at the padded rect corner so we can just draw at x/y
	x = padded_rect.x;
	y = padded_rect.y;
	
	if layout_props.size.w == "stretch" {
		image_xscale = padded_rect.w / sprite_get_width(sprite_index);
		draw_size.w = available_size.w;
	}
	else if layout_props.size.w == "center" {
		x += padded_rect.w / 2;
		image_xscale = 1;
		draw_size.w = available_size.w;
	}
	else {
		image_xscale = 1;
		draw_size.w = sprite_width + padding.w;
	}
	
	if layout_props.size.h == "stretch" {
		image_yscale = padded_rect.h / sprite_get_height(sprite_index);
		draw_size.h = available_size.h;
	}
	else if layout_props.size.w == "center" {
		y += padded_rect.h / 2;
		image_yscale = 1;
		draw_size.h = available_size.h;
	}
	else {
		image_yscale = 1;
		draw_size.h = sprite_height + padding.h;
	}
	
	// check if the sprite is bigger than the space
	if sprite_width > padded_rect.w || sprite_height > padded_rect.h {
		if is_numeric(layout_props.size.w) {
			// scale down
			image_xscale = padded_rect.w / sprite_get_width(sprite_index);
			draw_size.w = padded_rect.w + padding.w;
		}
		if is_numeric(layout_props.size.h) {
			// scale down
			image_yscale = padded_rect.h / sprite_get_height(sprite_index);
			draw_size.h = padded_rect.h + padding.h;
		}
		
		// stretch - scale to the size
		// other - draw_sprite_part to clip the image
	}
	
	// might need to use bbox size to accomodate rotated sprites?
	var drawn_size = yui_apply_element_size(layout_props.size, available_size, {
		w: draw_size.w,
		h: draw_size.h,
	});
	
	yui_resize_instance(self, drawn_size.w, drawn_size.h);
	return draw_size;
}