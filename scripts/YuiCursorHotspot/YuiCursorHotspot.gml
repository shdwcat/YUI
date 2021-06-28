/// @description here
function YuiCursorHotspot(_kind, _target, _handler) constructor {
	kind = _kind;
	
	switch kind {
		case YuiHotspotKind.rect:
			rect = _target;
			break;
		case YuiHotspotKind.instance:
			instance = _target;
			break;			
	}
	onHotspot = _handler; // function(hotspot, cursor_state)
	
	static cursorOnHotspot = function(cursor_pos) {
		switch kind {
			case YuiHotspotKind.rect:
				return yui_cursor_in_rect(cursor_pos, rect)
				break;
			case YuiHotspotKind.instance:
				return position_meeting(cursor_pos.x, cursor_pos.y, instance);
				break;			
		}
	}
}