/// @description init


interaction_map = yui_load_interactions();

overlay_gui_hotspots = ds_stack_create();
underlay_gui_hotspots = ds_stack_create();
overlay_world_hotspots = ds_stack_create();
underlay_world_hotspots = ds_stack_create();

// TODO: split into click/press/hover?
cursor_event_consumed = false;
cursor_event = undefined;
active_interaction = undefined;

/// @func pushHotspot(rect, handler, mode)
/// @desc pushes a rect hotspot for evaluation in the current frame
pushHotspot = function(rect, handler, mode) {
	
	var hotspot = new YuiCursorHotspot(YuiHotspotKind.rect, rect, handler);
	
	switch mode {
		case hotspot_mode.OverlayGUI:
			ds_stack_push(overlay_gui_hotspots, hotspot);
			break;
		case hotspot_mode.UnderlayGUI:
			ds_stack_push(underlay_gui_hotspots, hotspot);
			break;
		case hotspot_mode.OverlayWorld:
			ds_stack_push(overlay_world_hotspots, hotspot);
			break;
		case hotspot_mode.UnderlayWorld:
			ds_stack_push(underlay_world_hotspots, hotspot);
			break;
	}
}

/// @func pushInstanceHotspot(instance, handler, mode)
/// @desc pushes an instance hotspot for evaluation in the current frame
pushInstanceHotspot = function(instance, handler, mode) {
	
	var hotspot = new YuiCursorHotspot(YuiHotspotKind.instance, instance, handler);
	
	switch mode {
		case hotspot_mode.OverlayGUI:
			ds_stack_push(overlay_gui_hotspots, hotspot);
			break;
		case hotspot_mode.UnderlayGUI:
			ds_stack_push(underlay_gui_hotspots, hotspot);
			break;
		case hotspot_mode.OverlayWorld:
			ds_stack_push(overlay_world_hotspots, hotspot);
			break;
		case hotspot_mode.UnderlayWorld:
			ds_stack_push(underlay_world_hotspots, hotspot);
			break;
	}
}