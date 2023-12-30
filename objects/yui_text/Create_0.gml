/// @description init

// Inherit the parent event
event_inherited();

use_scribble = false;
scribble_element = undefined;
typist = undefined;

element_xoffset = 0;
element_yoffset = 0;

font = undefined;

viewport_part = undefined;
use_text_surface = false;
text_surface = undefined;
text_surface_w = 0;
text_surface_h = 0;

// used by yui_text_input
override_text = undefined;

onLayoutInit = function() {
	text_value = new YuiBindableValue(yui_element.props.text);
	animatable.text = text_value;
	
	color_value = new YuiBindableValue(yui_element.color);
	animatable.color = color_value;
	
	highlight_color = layout_props.highlight_color;
	use_scribble = layout_props.use_scribble;
}

build = function() {
	
	var text = override_text ?? bound_values.text;
	
	if use_scribble {
		scribble_element = scribble(text, string(id))
			.starting_format(bound_values.font)
			.align(layout_props.halign, layout_props.valign);
		
		if bound_values.typist {
			typist = bound_values.typist;
			typist.__associate(scribble_element);
		}
		else if layout_props.autotype != undefined {
			typist = scribble_typist();
			var autotype = layout_props.autotype;
			if autotype == true {
				typist.in(0.15, 0);
			}
			else if is_struct(autotype) {
				typist.in(autotype.speed, autotype.smoothness);
			}
			else {
				// TODO validate this in YuiTextElement
				throw yui_error("invalid autotype value");
			}
		}	
	}
	
	font = asset_get_index(bound_values.font);
}

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function yui_text__arrange(available_size, viewport_size) {
	if use_scribble && !scribble_element 
		return sizeToDefault();
	
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !visible {
		return sizeToDefault();
	}
	
	var padding = layout_props.padding;
	padded_rect = padding.apply(available_size, layout_props.size);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w < 0 || padded_rect.h < 0 {
		return sizeToDefault();
	}
	
	element_xoffset = padding.left;
	element_yoffset = padding.top;
	
	var desired_size = {};
		
	if use_scribble {
	
		scribble_element.wrap(padded_rect.w, padded_rect.h);
		var is_wrapped = scribble_element.get_wrapped();
		var new_bbox = scribble_element.get_bbox(x, y, padding.left, padding.top, padding.right, padding.bottom);

		desired_size.w = layout_props.halign or is_wrapped
			? available_size.w
			: new_bbox.width;
		desired_size.h = layout_props.valign
			? available_size.h
			: new_bbox.height;
	}
	else {
	
		//scribble_element.wrap(padded_rect.w, padded_rect.h);
		//var new_bbox = scribble_element.get_bbox(x, y, padding.left, padding.top, padding.right, padding.bottom);
	
		var old_font = draw_get_font();
		draw_set_font(font);
	
		// calc size
		var text = bound_values.text
		var native_width = string_width_ext(text, -1, padded_rect.w);
		var native_height = string_height_ext(text, -1, padded_rect.w);
		
		// check wrapped
		var native_width_nowrap = string_width(text);
		var is_wrapped = native_width_nowrap > padded_rect.w;
		
		//var render_width = new_bbox.width;
		//var render_height = max(new_bbox.height, string_height("bq"));
		
		//if native_width != 0 and abs(native_width - render_width) > 1
		//	DEBUG_BREAK_YUI
			
		//if abs(native_height - render_height) > 1
		//	DEBUG_BREAK_YUI
	
		draw_set_font(old_font);
	
		text_surface_w = native_width + padding.w;
	
		// can't use string_height_ext because it doesn't account for letters like pqyg
		text_surface_h = native_height + padding.h;
	
		// update draw size
		desired_size.w = layout_props.halign or is_wrapped
			? available_size.w
			: native_width;
		desired_size.h = layout_props.valign
			? available_size.h
			: native_height;
	}
	
	// account for padding
	desired_size.w += padding.w;
	desired_size.h += padding.h;
	
	// update draw size
	var drawn_size = element_size.constrainDrawSize(available_size, desired_size);
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	if trace {
		DEBUG_BREAK_YUI
	}
	
	use_text_surface = font >= 0 && !use_scribble;
	if use_text_surface {
		
		var build_surface = true;
		if viewport_size {
			updateViewport();
			
			if !viewport_part.visible {
				build_surface = false;
			}
		}
		
		if build_surface {
			buildTextSurface();
		}
	}
	
	// when centering, center on the center of the padded rect
	if layout_props.halign == fa_center {
		element_xoffset += padded_rect.w / 2;
	}
	if layout_props.valign == fa_middle {
		element_yoffset += padded_rect.h / 2;
	}
	
	return draw_size;
}

buildTextSurface = function yui_text__buildTextSurface(text = undefined) {
	
	if !bound_values return;
	
	if (text_surface_w > 0 && text_surface_h > 0) {

		text ??= override_text ?? bound_values.text;
				
		if trace {
			DEBUG_BREAK_YUI
		}
	
		text_surface = yui_draw_text_to_surface(
			element_xoffset, element_yoffset,
			text_surface_w, text_surface_h,
			text,
			text_surface_w - layout_props.padding.w,
			c_white, // color blending happens on surface draw
			opacity,
			layout_props.halign, layout_props.valign,
			font,
			text_surface);
	}
}