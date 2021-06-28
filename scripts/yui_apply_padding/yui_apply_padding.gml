/// @description returns a new rect with the padding applied to the draw rect
/// and the size of the effective padding that was applied
function yui_apply_padding(draw_rect, padding) {	
	var padded_rect = yui_copy_rect(draw_rect);
		
	if padding != 0 {
        if is_numeric(padding) {
            var pad_left = padding;
            var pad_top = padding;
            var pad_right = padding;
            var pad_bottom = padding;
        }
        else if is_array(padding) {
            var pad_left = padding[0];
            var pad_top = padding[1];
            
            if array_length(padding) = 4 {
                pad_right = padding[2];
                pad_bottom = padding[3];
            }
            else {
                pad_right = pad_left;
                pad_bottom = pad_top;
            }
        }
		
		var padding_size = {
			w: pad_left + pad_right,
			h: pad_top + pad_bottom,
		};
		
		padded_rect.x += pad_left;
		padded_rect.w -= padding_size.w;
		
		padded_rect.y += pad_top;
		padded_rect.h -= padding_size.h;
	}
	else {
		var padding_size = { w: 0, h: 0 };
	}
	
	return {
		padded_rect: padded_rect,
		padding_size: padding_size,
	};
}