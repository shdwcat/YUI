/// @description placeholder for not-yet-implemented types
function YuiNotImplemented(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		padding: 0,
	}
	
	props = init_props_old(_props);
	
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
		return false;
	}
}