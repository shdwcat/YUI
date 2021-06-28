/// @description Renders an overlay and adds it to the render context
/// @param render_context
/// @param target_rect
/// @param placement_mode
/// @param popup_renderer
/// @param data
/// @param item_index
/// @param [overlay_id]
function yui_render_overlay(
	render_context,
	target_result,
	placement,
	popup_renderer,
	data,
	item_index,
	overlay_id
	) {
		
	// TODO: allow popup to specify size constraints?
	var popup_draw_rect = {
		x: 0, y: 0,
		w: render_context.screen_size.w, // TODO: can be further bound by the position and placement
		h: render_context.screen_size.h, // e.g. if in middle of screen, draw_rect is a quadrant
	}
	
	if render_context.overlay_id != undefined {
		overlay_id += "|" + render_context.overlay_id
	}
	
	// copy the context so that we can track all hotspots for this overlay separately
	render_context = render_context.copy();
	render_context.overlay_id = overlay_id;
	render_context.hotspots = [];
	// could we just swap this array back out after rendering and store it on the placement? to avoid copy()
	
	var popup_result = popup_renderer.update(render_context, data, popup_draw_rect, item_index);
	if !popup_result {
		return;
	}
	
	// determine overlay placement mode
	placement = render_context.resolveBinding(placement, data)
	var mode = is_string(placement)
		? global.__yui_globals.placement_map[$ placement]
		: placement;
		
	// calculate the final overlay position from the target position
	var position = yui_calc_placement_position(
		target_result,
		mode,
		popup_result.w,
		popup_result.h);
		
	popup_result.finalize(position.x, position.y);

	var overlay = {
		id: overlay_id,
		ro_context: render_context, // needed to correctly handle hotspots in the overlay
		popup_result: popup_result,
	};
				
	render_context.addOverlay(overlay);
	
	return overlay;
}