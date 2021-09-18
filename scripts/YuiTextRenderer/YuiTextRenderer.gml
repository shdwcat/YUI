/// @description renders YUI text
function YuiTextRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {		
		type: "text",		
		theme: "default",
		padding: 0,
		
		text: noone,
		text_format: noone,
		
		text_style: "body",
		font: undefined, // overrides text_style.font
		
		centered: false,
		
		on_render: noone, // callback function on render, for advanced use
	};
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.text = yui_bind(props.text, _resources);
	
	// look up the text style by name from the theme
	text_style = theme.text_styles[$ props.text_style];
	
	size = new YuiElementSize(props.size);
		
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
		var is_visible = ro_context.resolveBinding(props.visible, data);
		if !is_visible return false;
		
		if props.trace {
			var f = "f";
		}
		
		var text = ro_context.resolveBinding(props.text, data);
		if text == noone || text == "" || text == undefined {
			return false
		}
		
		// handle text array by joining the values		
		if is_array(text) {
			var joined_text = "";
			var i = 0; repeat array_length(text) {
				var item_text = ro_context.resolveBinding(text[i++], data);
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
			
		if !is_string(font) font = font_get_name(font);
		else if !asset_get_index(font) {
			log ("could not find font with font name:", font, "- reverting to text_style.font");
			font = font_get_name(text_style.font);
		}
		
		if is_numeric(size.w) draw_rect.w = size.w;
		if is_numeric(size.h) draw_rect.h = size.h;
		
		var padding_info = yui_apply_padding(draw_rect, props.padding);
		var padded_rect = padding_info.padded_rect;
		var padding_size = padding_info.padding_size;
		var occurance = props.id = "" ? item_index : props.id;
		
		var halign = props.centered == true || props.centered == "x"
			? fa_center
			: fa_left
			
		var valign = props.centered == true || props.centered == "y"
			? fa_middle
			: fa_top
		
		var element = scribble(text, occurance)
			.starting_format(font, text_style.color)
			.align(halign, valign)
			.wrap(padded_rect.w, padded_rect.h)	
		
		var _x = padded_rect.x;
		var _y = padded_rect.y;
		
		// when centering, center on the center of the padded rect
		if halign == fa_center {
			var _x = padded_rect.x + padded_rect.w / 2;
		}
		if valign == fa_middle {
			var _y = padded_rect.y + padded_rect.h / 2;
		}
		
		// make sure text is never off-pixel (ceil ensures we don't overlap with something 'before')
		_x = ceil(_x);
		_y = ceil(_y);	
		
		var renderer = self;
						
		var result = yui_instruction({
			x: draw_rect.x,
			y: draw_rect.y,
			w: element.get_width() + padding_size.w,
			h: element.get_height() + padding_size.h,
			
			// whew this is a lot just for auto type
			renderer: renderer,
			on_render: props.on_render,
			data: props.on_render ? data : undefined,
			ro_context: ro_context,
			
			element: element,
			element_x: _x, // these are the offsets for the scribble text element, from padding/centering
			element_y: _y,
			
			trace: props.trace,
			
			draw: function() {
				yui_call_event_handler(on_render, renderer, ro_context, data, element);
				
				element.draw(x + element_x, y + element_y);
				
				// trace the final draw size
				yui_draw_trace_rect(trace, self, c_lime);
				
			},
		});
		
		// HACK: actually turn the element coords into offsets
		// TODO; calculate them as offsets to begin with!
		result.element_x -= result.x;
		result.element_y -= result.y;
		
		
		if halign == fa_center {
			result.w = draw_rect.w;
		}
		if valign == fa_middle {
			result.h = draw_rect.h
		}
		
		yui_render_tooltip_if_any(ro_context, result, props, data, item_index);
		
		return result;
	}
}