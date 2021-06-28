/// @description check underlay GUI hotspots

// TODO: this needs to move to begin step/end step, since that's where YUI hotspots are now handled

if !cursor_event_consumed {
	
	var consumed = false;
	
	// check gui
	repeat ds_stack_size(underlay_gui_hotspots) {
		var hotspot = ds_stack_pop(underlay_gui_hotspots);
	
		// get cursor state
		cursor_state_gui.hover = hotspot.cursorOnHotspot(cursor_state_gui)
			
		// handle the hotspot
		var hotspot_consumed = hotspot.onHotspot(hotspot, cursor_state_gui, cursor_event) || false;
		consumed |= hotspot_consumed;
			
		// skip if the event was consumed
		if consumed break;
	}
	
	// check world
	repeat ds_stack_size(underlay_world_hotspots) {
		var hotspot = ds_stack_pop(underlay_world_hotspots);
	
		// get cursor state
		cursor_state.hover = hotspot.cursorOnHotspot(cursor_state)
			
		// handle the hotspot
		var hotspot_consumed = hotspot.onHotspot(hotspot, cursor_state, cursor_event) || false;
		consumed |= hotspot_consumed;
			
		// skip if the event was consumed
		if consumed break;
	}

	cursor_event_consumed = consumed;
}