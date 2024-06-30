/// @description 

// clear the sprite so that we don't accidentally draw the YUI sprite when no sprite is bound
sprite_index = -1;

mirror_x = false;
mirror_y = false;

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
	
	mirror_x = bound_values.mirror_x;
	mirror_y = bound_values.mirror_y;
	
	if trace {
		DEBUG_BREAK_YUI
	}
}

/// @param {struct.YuiArrangeSize} arrange_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {

	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !visible {
		return sizeToDefault();
	}
	
	var padding = layout_props.padding;	
	padded_rect = padding.apply(available_size, layout_props.size, bound_values);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w <= 0 || padded_rect.h <= 0 {
		return sizeToDefault();
	}
	
	var desired_size = {};
	
	// width
	
	if layout_props.size.w_type == YUI_LENGTH_TYPE.Proportional {
		// assume we want to stretch the sprite to fit the proportional space
		image_xscale = padded_rect.w / sprite_get_width(sprite_index);
		// only use the proportion
		desired_size.w = padded_rect.w + padding.w;
	}
	else if layout_props.size.w == "stretch" {
		image_xscale = padded_rect.w / sprite_get_width(sprite_index);
		desired_size.w = available_size.w;
	}
	else if layout_props.size.w == "center" {
		x += padded_rect.w / 2;
		image_xscale = 1;
		desired_size.w = available_size.w;
	}
	else {
		image_xscale = 1;
		desired_size.w = sprite_width + padding.w;
	}
	
	// height
	
	if layout_props.size.h_type == YUI_LENGTH_TYPE.Proportional {
		// assume we want to stretch the sprite to fit the proportional space
		image_yscale = padded_rect.h / sprite_get_height(sprite_index);
		// only use the proportion
		desired_size.h = padded_rect.h + padding.h;
	}
	else if layout_props.size.h == "stretch" {
		image_yscale = padded_rect.h / sprite_get_height(sprite_index);
		desired_size.h = available_size.h;
	}
	else if layout_props.size.w == "center" {
		y += padded_rect.h / 2;
		image_yscale = 1;
		desired_size.h = available_size.h;
	}
	else {
		image_yscale = 1;
		desired_size.h = sprite_height + padding.h;
	}
	
	// check if the sprite is bigger than the space
	if sprite_width > padded_rect.w || sprite_height > padded_rect.h {
		if is_numeric(layout_props.size.w) {
			// scale down
			image_xscale = padded_rect.w / sprite_get_width(sprite_index);
			desired_size.w = padded_rect.w + padding.w;
		}
		if is_numeric(layout_props.size.h) {
			// scale down
			image_yscale = padded_rect.h / sprite_get_height(sprite_index);
			desired_size.h = padded_rect.h + padding.h;
		}
		
		// stretch - scale to the size
		// other - draw_sprite_part to clip the image
	}
	
	// might need to use bbox size to accomodate rotated sprites?
	var drawn_size = element_size.constrainDrawSize(available_size, desired_size);
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	// apply mirroring after sizing
	if mirror_x {
		image_xscale = -image_xscale;
		padded_rect.x += abs(sprite_width);
	}
	if mirror_y {
		image_yscale = -image_yscale;
		padded_rect.y += abs(sprite_height);
	}
	
	// position at the padded rect corner so we can just draw at x/y
	x = padded_rect.x;
	y = padded_rect.y;

	// probably unnecessary but keeping for reference
	//if viewport_size {
	//	updateViewport();
	//}
			
	return draw_size;
}

Inspectron()
	.Section("yui_image")
	//.Sprite(nameof(sprite_index))
	.SpritePicker(nameof(sprite_index));