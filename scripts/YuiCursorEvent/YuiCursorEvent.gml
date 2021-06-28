/// @description Tracks the consumption of cursor-related events per frame
function YuiCursorEvent() constructor {
	//all_consumed: false, // for interop with external hotspots
	
	tooltip_consumed = false;
	hover_consumed = false;
	
	cursor_press_consumed = false;
	cursor_release_consumed = false;
	cursor_click_consumed = false;
	click_overlay_id = undefined;
	
	/// @func consumeClick(overlay_id)
	/// @arg overlay_id - the id of the overlay that consumed the click
	static consumeClick = function(overlay_id) {
		cursor_release_consumed = true;
		cursor_click_consumed = true;
		click_overlay_id = overlay_id;
	}
}