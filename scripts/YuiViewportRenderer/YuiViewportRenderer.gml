/// @description renders all or part of the inner YUI content to a surface
function YuiViewportRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		type: "viewport",
		
		content: noone,
		
		view_size: "auto",
		overflow: {
			h: "clip", // or "spill" | "fit",
			v: "clip", // or "spill" | "fit",
		},
		
		xoffset: 0,
		
		// should scrolling just go here for perf reasons?
	}
	
	props = init_props_old(_props);
	
	content_renderer = yui_resolve_renderer(props.content, _resources);
	
	// ===== functions =====
			
	static update = function(ro_context, data, draw_rect, item_index) {
		
		// TODO: this should be determined by size, as it may be bigger than the draw_rect
		var content_draw_rect = yui_copy_rect(draw_rect);
		
		//update child content
		var content_result = content_renderer.update(ro_context, data, content_draw_rect, item_index);
		
		var result = yui_instruction({
			x: draw_rect.x,
			y: draw_rect.y,
			w: draw_rect.w,
			h: draw_rect.h,
			
			child: content_result,
			
			draw: function() {
				// draw the surface
				
				throw "Viewport.draw not implememented yet";
				
				//yui_draw_alpha_surface_part(
				//	content_surface,
				//	0, 0, w, h, // TODO this needs to adjust for overflow setting
				//	x + props.xoffset,
				//	y); // todo: y_offset
			}
		});		
			
		yui_render_tooltip_if_any(ro_context, result, props, data, item_index);
		
		return result;
	}
	
	// ============================================================
	// NOTE:  preserved until i can re-implement the update version
	// ============================================================
	
	static render = function(ro_context, draw_rect) {
	
		// TODO: set this according to props.view_size
		var content_draw_rect = snap_deep_copy(draw_rect);
		
		// render the content to a surface
		var surface_key = ro_context.getSurfaceKey(props);
		var render_result = content_renderer.renderToSurface(ro_context, content_draw_rect, surface_key);
		
		var content_surface = render_result.surface;
		var content_size = render_result.size;
				
		// draw the surface
		yui_draw_alpha_surface_part(
			content_surface,
			0, 0, content_size.w, content_size.h, // TODO this needs to adjust for overflow setting
			content_draw_rect.x + props.xoffset, content_draw_rect.y);
			
		yui_render_tooltip_if_any(ro_context, content_size, props);
		
		// TODO: this needs to be adjusted when viewport clipping is implemented
		return content_size;
	}
}