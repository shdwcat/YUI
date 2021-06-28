/// @description renders a YUI Image
function YuiImageRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		type: "image",			
		theme: "default",
		padding: 0,
		scale_mode: "slice", // stretch/tile/clip/none/etc
		center: false,
		
		sprite: noone,
		ignore_sprite_origin: true, // default to draw as if origin is 0,0
		frame: 0,		
		opacity: 1,
		angle: 0,
		blend_color: c_white,
	};
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.sprite = yui_bind(props.sprite, _resources);
	props.frame = yui_bind(props.frame, _resources);
	props.size = yui_bind(props.size, _resources);
	props.angle = yui_bind(props.angle, _resources);
	props.opacity = yui_bind(props.opacity, _resources);
	props.blend_color = yui_bind(props.blend_color, _resources);
	
	// ===== functions =====

	static update = function(ro_context, data, draw_rect, item_index) {
		
		var is_visible = ro_context.resolveBinding(props.visible, data);
		if !is_visible return false;
		
		var sprite_name = ro_context.resolveBinding(props.sprite, data);
		
		// get the sprite asset from the name
		var sprite = yui_resolve_sprite_by_name(sprite_name, ro_context.resources);
		if sprite == -1 {
			sprite = noone; // TODO pink placeholder warning sprite
		}
		
		// this also copies the draw_rect
		var padding_info = yui_apply_padding(draw_rect, props.padding);
		padded_rect = padding_info.padded_rect;
				
		var _x = props.center == true || props.center == "x"
			? padded_rect.x + padded_rect.w / 2
			: padded_rect.x;
			
		var _y = props.center == true || props.center == "y"
			? padded_rect.y + padded_rect.h / 2
			: padded_rect.y;
		
		var xscale = 1;
		var yscale = 1;
		
		var size = ro_context.resolveBinding(props.size, data);		
		
		if size == "auto" && sprite != noone {
			var draw_size = {
				w: min(padded_rect.w, sprite_get_width(sprite)),
				h: min(padded_rect.h, sprite_get_height(sprite)),
			};
		}
		else if size == "stretch" && sprite != noone {
			var draw_size = padded_rect;
			// TODO: use draw_sprite_stretched?
			var transform = yui_get_sprite_scale_transform(draw_size.w, draw_size.h, sprite);
			var xscale = transform[0];
			var yscale = transform[1];
		}
		else if is_struct(size) {
			var draw_size = {
				w: min(padded_rect.w, size.w),
				h: min(padded_rect.h, size.h),
			};
			// TODO: use draw_sprite_stretched?
			var transform = yui_get_sprite_scale_transform(draw_size.w, draw_size.h, sprite);
			var xscale = transform[0];
			var yscale = transform[1];
		}
		else {
			// no sprite and no size means skip drawing this
			return false;
		}
		
		var result = yui_instruction({
			x: draw_rect.x,
			y: draw_rect.y,
			w: draw_size.w + padding_info.padding_size.w,
			h: draw_size.h + padding_info.padding_size.h,
			
			trace: props.trace,
		});
		
		// TODO support clipping by using draw_sprite_part!
		if sprite != noone {
			// TODO: fix _x and _y to be offsets not coords
			result.sprite_x_offset = _x - result.x;
			result.sprite_y_offset = _y - result.y;
			
			if props.ignore_sprite_origin {
				result.sprite_x_offset += xscale * sprite_get_xoffset(sprite);
				result.sprite_y_offset += yscale * sprite_get_yoffset(sprite);
			}			
			
			result.sprite = sprite;
			result.xscale = xscale;
			result.yscale = yscale;
			result.frame = ro_context.resolveBinding(props.frame, data);
			result.angle = ro_context.resolveBinding(props.angle, data);
			result.opacity = ro_context.resolveBinding(props.opacity, data);			
			result.blend_color = yui_resolve_color(ro_context.resolveBinding(props.blend_color, data));
			
			with result {
				draw = function() {
										
					draw_sprite_ext(
						sprite, frame,
						x + sprite_x_offset, y + sprite_y_offset,
						xscale, yscale,
						angle, blend_color, opacity);
				
					yui_draw_trace_rect(trace, self, c_yellow);
			
					//if props.scale_mode == "tile" {
					//	draw_sprite_tiled_ext(sprite, frame, x + sprite_x_offset, y + sprite_y_offset)
					//}
				};
			}
		}
		else {
			result.draw = function() {};
		}
		
		yui_render_tooltip_if_any(ro_context, result, props, data, item_index);
		
		return result;
	}
}