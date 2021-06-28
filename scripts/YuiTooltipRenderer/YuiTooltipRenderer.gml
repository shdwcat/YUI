/// @description here
function YuiTooltipRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {		
		type: "button",
		theme: "default",
		
		size: "auto", // can also be { w: val, h: val } where val can be a number or "auto" | "content"
		
		// default to theme values
		bg_color: undefined,
		border_color: undefined,
		border_thickness: undefined,		
		padding: undefined,
		
		content: undefined,
	}
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.size = new YuiElementSize(props.size);
	
	// TODO: clean up initializing props from theme
	
	if props.bg_color == undefined {
		props.bg_color = theme.tooltip.bg_color;
	}
	else {
		props.bg_color = yui_resolve_color(props.bg_color);
	}
	
	if props.border_color == undefined {
		props.border_color = theme.tooltip.border_color;
	}
	else {
		props.border_color = yui_resolve_color(props.border_color);
	}
	
	if props.border_thickness == undefined {
		props.border_thickness = theme.tooltip.border_thickness;
	}
	if props.padding == undefined {
		props.padding = theme.tooltip.padding;
	}
	
	content_renderer = yui_resolve_renderer(props.content, _resources);
	
	static update = function(ro_context, data, draw_rect, item_index) {
		
		if is_numeric(props.size.w) draw_rect.w = props.size.w;
		if is_numeric(props.size.h) draw_rect.h = props.size.h;
		
		var padding_info = yui_apply_padding(draw_rect, props.padding);
		
		var content_result = content_renderer.update(ro_context, data, padding_info.padded_rect, item_index);
		if !content_result {
			return false;
		}
		
		var renderer = self;
		
		var result = yui_instruction({
			x: draw_rect.x,
			y: draw_rect.y,
			w: content_result.w + padding_info.padding_size.w,
			h: content_result.h + padding_info.padding_size.h,
			
			renderer: renderer,
			content: content_result,
			
			draw: function() {				
				renderer.drawBackground(self);			
				content.draw();	
				renderer.drawBorder(self);
			},
		});
		
		return result;			
	}
	
	static drawBackground = function(draw_rect) {
		if props.bg_color != noone {			
			draw_rectangle_color(
				draw_rect.x, draw_rect.y,
				draw_rect.x + draw_rect.w - 1, draw_rect.y + draw_rect.h - 1,
				props.bg_color, props.bg_color, props.bg_color, props.bg_color, false);
		}
	}
	
	static drawBorder = function(draw_rect) {
		// draw border
		if props.border_color != noone {
			if props.border_thickness > 0 {				
				yui_draw_rect_outline(
					draw_rect.x, draw_rect.y, draw_rect.w, draw_rect.h,
					props.border_thickness, props.border_color);
			}
		}
	}
}