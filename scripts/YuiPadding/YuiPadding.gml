/// @param {real,array<real>} padding
function YuiPadding(padding) constructor {

	if is_numeric(padding) {
        left = padding;
        top = padding;
        right = padding;
        bottom = padding;
    }
    else if is_array(padding) {
        left = padding[0];
        top = padding[1];
            
        if array_length(padding) = 4 {
            right = padding[2];
            bottom = padding[3];
        }
        else {
            right = left;
            bottom = top;
        }
    }
	else if is_struct(padding) {
		result = padding;
	}
		
	w = left + right;
	h = top + bottom;
	
	/// @desc  returns a new rect with the padding applied to the draw rect and the size of the effective padding that was applied
	/// @param {struct} draw_rect the available size
	/// @param {struct.YuiElementSize} element_size element size props
	/// @param {struct} [bound_values]
	static apply = function(draw_rect, element_size, bound_values = undefined) {
		
		var max_w = draw_rect.w;
		var max_h = draw_rect.h;
		
		if element_size {		
			max_w = min(draw_rect.w, element_size.max_w);
			max_h = min(draw_rect.h, element_size.max_h);
		
			if bound_values {
				var width = bound_values.w;
				var height = bound_values.h;
			}
			else {
				var width = element_size.w;
				var height = element_size.h;
			}
		
			if is_numeric(width) {			
				if element_size.w_type == YUI_LENGTH_TYPE.Proportional {
					max_w = width * max_w;
				}
				else {
					max_w = width;
				}
			}
		
			if is_numeric(height) {
				if element_size.h_type == YUI_LENGTH_TYPE.Proportional {
					max_h = height * max_h;
				}
				else {
					max_h = height;
				}
			}
		}
	
		var padded_rect = {
			x: draw_rect.x + left,
			y: draw_rect.y + top,
			w: max_w - w,
			h: max_h - h,
		};
	
		return padded_rect;
	}
	
	static inspectron = Inspectron()
		.Watch(nameof(left))
		.Watch(nameof(top))
		.Watch(nameof(right))
		.Watch(nameof(bottom))
}