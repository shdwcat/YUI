
function YuiPopupRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		type: "popup",	
		theme: "default",
		
		placement: placement_mode.BottomRight,
		content: undefined,
		
		// default to theme values
		bg_color: undefined,
		border_color: undefined,
		border_thickness: undefined,		
		padding: undefined,
	}
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	// TODO: clean up initializing props from theme
	
	if props.bg_color == undefined {
		props.bg_color = theme.popup.bg_color;
	}
	else {
		props.bg_color = yui_resolve_color(props.bg_color);
	}
	
	if props.border_color == undefined {
		props.border_color = theme.popup.border_color;
	}
	else {
		props.border_color = yui_resolve_color(props.border_color);
	}
	
	if props.border_thickness == undefined {
		props.border_thickness = theme.popup.border_thickness;
	}
	if props.padding == undefined {
		props.padding = theme.popup.padding;
	}
	
	content_renderer = yui_resolve_renderer(props.content, _resources);
	
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
		
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
		
		// handle any basic event hotspots
		pushEventHotspotIfAny(ro_context, data, result, item_index);
		
		// add a hotspot to catch clicks in this layer
		ro_context.addHotspot(
			result,
			renderer,
			onHotspot,
			props.trace,
			data,
			item_index);
		
		return result;		
	}
	
	static onHotspot = function(hotspot, cursor_state, cursor_event) {
		// catch any cursor clicks
		var clicked = !cursor_event.cursor_click_consumed && mouse_check_button_released(mb_any);
		if clicked && cursor_state.hover {
			// call the click handler
			cursor_event.consumeClick(hotspot.ro_context.overlay_id);
			//yui_log("popup", props.id, "consumed release and click for layer", hotspot.ro_context.overlay_id);
		}
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