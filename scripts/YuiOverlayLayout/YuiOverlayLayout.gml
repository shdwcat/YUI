
function YuiOverlayLayout() : YuiLayoutBase() constructor {
	alignment = { vertical: "stretch", horizontal: "stretch" };

	static update = function(item_render_size, spacing) {
		// overlay doesn't need to adjust any sizes while drawing
		return true;
	};
	
	static complete = function() {
		return draw_rect;
	};
}