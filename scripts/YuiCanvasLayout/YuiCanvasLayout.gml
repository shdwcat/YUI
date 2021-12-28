
function YuiCanvasLayout() : YuiLayoutBase() constructor {
	_right_aligned = false;
	_bottom_aligned = false;
	_center_h = false;
	_center_v = false;
	
	// static base_getItemDrawRect = getItemDrawRect;
	static getItemDrawRect = function(item_index, item_props) {
		var canvas_position = item_props[$ "canvas"];
		if canvas_position == undefined {
			// make a copy so that the item renderer can't accidentally mess up our draw rect
			var item_draw_rect = {
				x: current_draw_rect.x,
				y: current_draw_rect.y,
				w: current_draw_rect.w,
				h: current_draw_rect.h,
			};
			return item_draw_rect;
			
		}
		else {
			var left = canvas_position[$ "left"];
			var top = canvas_position[$ "top"];
			right = canvas_position[$ "right"];
			bottom = canvas_position[$ "bottom"];
			
			var center = canvas_position[$ "center"];
			_center_h = center == true || center == "h";
			_center_v = center == true || center == "v";
			
			if left == undefined {
				left = 0;
				_right_aligned = right != undefined;
			}
			else {
				_right_aligned = false;
			}
			
			if top == undefined {
				top = 0;
				_bottom_aligned = bottom != undefined;
			}
			else {
				_bottom_aligned = false;
			}
			
			if right == undefined right = 0;
			if bottom == undefined bottom = 0;
			
			var rect = {
				x: current_draw_rect.x + left,
				y: current_draw_rect.y + top,
				w: current_draw_rect.w - (left + right),
				h: current_draw_rect.h - (top + bottom),
			};
			return rect;
		}
	}

	static update = function(item_render_result, spacing) {
				
		if _right_aligned {
			item_render_result.panel_position.x += current_draw_rect.w - item_render_result.w - right;
			item_render_result.panel_position.needs_finalize = true;
		}
		if _bottom_aligned {
			item_render_result.panel_position.y += current_draw_rect.h - item_render_result.h - bottom;
			item_render_result.panel_position.needs_finalize = true;
		}
		if _center_h {
			item_render_result.panel_position.x += floor(current_draw_rect.w / 2 - (item_render_result.w / 2));
			item_render_result.panel_position.needs_finalize = true;
		}
		if _center_v {
			item_render_result.panel_position.y += floor(current_draw_rect.h / 2- (item_render_result.h / 2));
			item_render_result.panel_position.needs_finalize = true;
		}
		
		// canvas items never consume available space, so we can always draw more
		return true;
	};
	
	static complete = function() {
		return draw_rect;
	};
}