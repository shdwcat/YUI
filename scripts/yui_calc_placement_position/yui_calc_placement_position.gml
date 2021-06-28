enum placement_mode {
	TopLeft = 0,
	TopCenter = 1,
	TopRight = 2,
	LeftTop = 3,
	LeftCenter = 4,
	LeftBottom = 5,
	BottomLeft = 6,
	BottomCenter = 7,
	BottomRight = 8,
	RightTop = 9,
	RightCenter = 10,
	RightBottom = 11,	
}

/// @description calculate placement position based on mode and target
/// @arg target_rect	- the rectangle that position is being calculated relative to
/// @arg placement_mode - where the thing should be places relative to the target
/// @arg draw_width		- the width of the thing being placed
/// @arg draw_height	- the height of the thing being placed
/// @arg [x_margin]		- buffer between items when placed on Left or Right edge
/// @arg [y_margin]		- buffer between items when placed on Top or Bottom edge
function yui_calc_placement_position(
	target_rect,
	_placement_mode,
	draw_width,
	draw_height
	) {
	var x_margin = argument_count > 4 ? argument[4] : 0;
	var y_margin = argument_count > 5 ? argument[5] : 0;

	// x-axis calculation
	switch (_placement_mode) {
	
		// position starting at the left edge of the target
		case placement_mode.TopLeft:
		case placement_mode.BottomLeft:
			var xx = target_rect.x
			break;
	
		// position at the x-origin of the target
		case placement_mode.TopCenter:
		case placement_mode.BottomCenter:
			var xx = target_rect.x
				- draw_width / 2;
			break;
		
		// align the right edge of the item being placed with the right edge of the target
		case placement_mode.TopRight:
		case placement_mode.BottomRight:
			var xx = target_rect.x
				+ target_rect.w
				- draw_width;
			break;
		
		// position at the left edge of the target
		case placement_mode.LeftTop:
		case placement_mode.LeftBottom:
		case placement_mode.LeftCenter:
			var xx = target_rect.x
				- draw_width;
			break;
		
		// position at the right edge of the target
		case placement_mode.RightTop:
		case placement_mode.RightBottom:
		case placement_mode.RightCenter:
			var xx = target_rect.x
				+ target_rect.w;
			break;
	}

	// y-axis calculation
	switch (_placement_mode) {
	
		// position above the top edge of the target
		case placement_mode.TopLeft:
		case placement_mode.TopCenter:
		case placement_mode.TopRight:
		
			var yy = target_rect.y
				- draw_height
				- y_margin;	
			
			break;
	
		// position below the bottom edge of the target
		case placement_mode.BottomLeft:
		case placement_mode.BottomCenter:
		case placement_mode.BottomRight:
		
			var yy = target_rect.y
				+ target_rect.h
				+ y_margin;	
			
			break;
	
		// position below the top edge of the target
		case placement_mode.LeftTop:
		case placement_mode.RightTop:
		
			var yy = target_rect.y;
			break;
	
		// position the bottom edge of the tooltip along the bottom edge of the target
		case placement_mode.LeftBottom:
		case placement_mode.RightBottom:
		
			var yy = target_rect.y
				+ target_rect.h
				- draw_height;
			break;
	}

	return { x: xx, y: yy };
}
