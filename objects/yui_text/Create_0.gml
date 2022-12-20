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
	highlight_color = layout_props.highlight_color;
	use_scribble = layout_props.use_scribble;
}

build = function() {
	
	// used in Draw GUI
	text_color = bound_values.color;
	
	var text = override_text ?? bound_values.text;
		
	scribble_element = scribble(text, string(id))
		.starting_format(bound_values.font)
		.align(layout_props.halign, layout_props.valign);
	
	if bound_values.typist {
		typist = bound_values.typist;
		typist.__associate(scribble_element);
	}
	else if bound_values.autotype != undefined {
		typist = scribble_typist();
		var autotype = bound_values.autotype;
		if autotype == true {
			typist.in(0.15, 0);
		}
		else if is_struct(autotype) {
			typist.in(autotype.speed, autotype.smoothness);
		}
		else {
			throw "invalid autotype value";
		}
	}	
	
	font = asset_get_index(bound_values.font);
}

arrange = function(available_size, viewport_size) {
	if !scribble_element 
		return sizeToDefault(available_size);
	
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !visible {
		return sizeToDefault(available_size);
	}
	
	var padding = layout_props.padding;
	padded_rect = yui_apply_padding(available_size, padding, layout_props.size);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w < 0 || padded_rect.h < 0 {
		return sizeToDefault(available_size);
	}
	
	element_xoffset = padding.left;
	element_yoffset = padding.top;
	
	//if trace {
	//	DEBUG_BREAK_YUI;
	//}
	
	scribble_element.wrap(padded_rect.w, padded_rect.h);

	var new_bbox = scribble_element.get_bbox(x, y, padding.left, padding.top, padding.right, padding.bottom);
	
	
	var old_font = draw_get_font();
	draw_set_font(font);
	
	var render_width = new_bbox.width;
	var render_height = max(new_bbox.height, string_height("bq"));
	
	draw_set_font(old_font);
	
	text_surface_w = render_width + padding.w;
	
	// can't use string_height_ext because it doesn't account for letters like pqyg
	text_surface_h = new_bbox.height + padding.h;
	
	// update draw size
	var draw_width = layout_props.halign
		|| scribble_element.get_wrapped() ? available_size.w : render_width;
	var draw_height = layout_props.valign ? available_size.h : render_height;
	
	var drawn_size = yui_apply_element_size(layout_props.size, available_size, {
		w: draw_width + padding.w,
		h: draw_height + padding.h,
	});
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	if bound_values && (bound_values.xoffset != 0 || bound_values.yoffset != 0) {
		move(bound_values.xoffset, bound_values.yoffset);
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

buildTextSurface = function() {
	
	if !bound_values return;
	
	if (text_surface_w > 0 && text_surface_h > 0) {

		var text = override_text ?? bound_values.text;
	
		text_surface = yui_draw_text_to_surface(
			element_xoffset, element_yoffset,
			text_surface_w, text_surface_h,
			text,
			text_surface_w - layout_props.padding.w,
			text_color ?? c_white,
			opacity,
			layout_props.halign, layout_props.valign,
			font,
			text_surface);
	}
}






