/// @description renders text using the default GML text rendering function
function YuiBasicTextRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {		
		type: "basic_text",		
		theme: YuiGlobals.default_theme,
		padding: 0,
		
		text: noone,
		text_format: noone,
		path: noone, // defines the source path for the text content
		
		text_style: "body",
		font: undefined, // overrides text_style.font
		
		centered: false,
	};
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.text = yui_bind(props.text, _resources);
	
	// look up the text style by name from the theme
	text_style = props.theme.props.text_styles[$ props.text_style];
	
	// TODO: convert this to update()!
	
	static render = function(ro_context, draw_rect) {
		
		var is_visible = ro_context.resolveBinding(props.visible);
		if !is_visible return { w: 0, h: 0 };
		
		var text = ro_context.resolveBinding(props.text);
		if text == noone || text == "" || text == undefined {
			return { w: 0, h: 0 };
		}
		
		// handle text array by joining the values
		if is_array(text) {
			var joined_text = "";
			var i = 0; repeat array_length(text) {
				var item_text = ro_context.resolveBinding(text[i++]);
				joined_text += string(item_text);
			}
			text = joined_text;
		}
			
		if props.text_format != noone
		{
			text = string_replace(props.text_format, "{0}", text);
		}
		
		var font = props.font == undefined
			? text_style.font
			: props.font;
			
		if is_string(font) font = asset_get_index(font);
		
		var padding_info = yui_apply_padding(draw_rect, props.padding);
		var padded_rect = padding_info.padded_rect;
		var padding_size = padding_info.padding_size;
		
		var halign = props.centered == true || props.centered == "x"
			? fa_center
			: fa_left;
			
		var valign = props.centered == true || props.centered == "y"
			? fa_middle
			: fa_top;
		
		var _x = padded_rect.x;
		var _y = padded_rect.y;
		
		if halign == fa_center {
			var _x = padded_rect.x + padded_rect.w / 2;
		}
		if valign == fa_middle {
			var _y = padded_rect.y + padded_rect.h / 2;
		}
		
		// make sure text is never off-pixel (ceil ensures we don't overlap with something 'before')
		_x = ceil(_x);
		_y = ceil(_y);
		
		var old_font = draw_get_font();
		draw_set_font(asset_get_index(font));
		var text_w = string_width_ext(text, -1, padded_rect.w);
		var text_h = string_height_ext(text, -1, padded_rect.w);
		draw_text_ext(_x, _y, text, -1, padded_rect.w);
		draw_set_font(old_font);
		
		var final_rect = {
			x: _x, y: _y,
			w: text_w + padding_size.w,
			h: text_h + padding_size.h,
		};

		// trace the final draw size
		yui_draw_trace_rect(props, final_rect, c_fuchsia);
		yui_draw_trace_rect(props, draw_rect, c_lime);
		
		yui_render_tooltip_if_any(ro_context, final_rect, props);
		
		return final_rect;
	}
}