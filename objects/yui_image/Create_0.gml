/// @description 

// clear the sprite so that we don't accidentally draw the YUI sprite when no sprite is bound
sprite_index = -1;

// Inherit the parent event
event_inherited();

onLayoutInit = function() {
	
	frame_value = new YuiBindableValue(yui_element.props.frame);
	angle_value = new YuiBindableValue(yui_element.props.angle);
	blend_color_value = new YuiBindableValue(yui_element.props.blend_color);
	
	animatable.frame = frame_value;
	animatable.angle = angle_value;
	animatable.blend_color = blend_color_value;
}

build = function() {
	if bound_values.sprite >= 0 {
		sprite_index = bound_values.sprite;
	}
	else {
		visible = false;
	}
	
	if trace {
		DEBUG_BREAK_YUI
	}
}

arrange = function(available_size, viewport_size) {

	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !visible {
		return sizeToDefault(available_size);
	}
	
	var padding = layout_props.padding;	
	padded_rect = yui_apply_padding(available_size, padding, layout_props.size, bound_values);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w <= 0 || padded_rect.h <= 0 {
		return sizeToDefault(available_size);
	}
	
	
	if layout_props.size.w_type == YUI_LENGTH_TYPE.Proportional {
		// assume we want to stretch the sprite to fit the proportional space
		image_xscale = padded_rect.w / sprite_get_width(sprite_index);
		// only use the proportion
		draw_size.w = padded_rect.w + padding.w;
	}
	else if layout_props.size.w == "stretch" {
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
	
	if layout_props.size.h_type == YUI_LENGTH_TYPE.Proportional {
		// assume we want to stretch the sprite to fit the proportional space
		image_yscale = padded_rect.h / sprite_get_height(sprite_index);
		// only use the proportion
		draw_size.h = padded_rect.h + padding.h;
	}
	else if layout_props.size.h == "stretch" {
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
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	// position at the padded rect corner so we can just draw at x/y
	x = padded_rect.x;
	y = padded_rect.y;
	
	if viewport_size {
		updateViewport();
	}
			
	return draw_size;
}