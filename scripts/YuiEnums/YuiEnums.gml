// TODO figure out enum naming convention

enum YuiCursorEvents {
	auto, // root element of a document will consume cursor events in its draw_rect
	pass_through, // cursor events at the element level will be passed through to the next layer
	consume_all, // cursor events do not propagate above this element
	//none, // not yet implemented
};

function yui_parse_cursor_events_enum(enum_value) {
	if !is_string(enum_value) return enum_value;
	
	switch (enum_value) {
		case "auto":
			return YuiCursorEvents.auto;
		case "pass_through":
			return YuiCursorEvents.pass_through;
		case "consume_all":
			return YuiCursorEvents.consume_all;
	}
}

enum YuiHotspotKind {
	rect,
	instance,
}

enum hotspot_mode {
	OverlayGUI,
	UnderlayGUI,
	OverlayWorld,
	UnderlayWorld,
}