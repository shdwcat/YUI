/// @desc fills out padding values on the provided draw_rect
function yui_calc_padding(draw_rect, padding) {
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
        
        // not sure we need these on draw_rect (can calc 'draw_rect.w - draw_rect.pad_rect_w' if needed)
        draw_rect.pad_size_w = pad_left + pad_right;
        draw_rect.pad_size_h = pad_top + pad_bottom;
        
        draw_rect.pad_x = draw_rect.x + pad_left;
        draw_rect.pad_y = draw_rect.y + pad_top;        
        draw_rect.pad_rect_w = draw_rect.w - draw_rect.pad_size_w;
        draw_rect.pad_rect_h = draw_rect.h - draw_rect.pad_size_h;
    }
    else {
        draw_rect.pad_x = draw_rect.x;
        draw_rect.pad_y = draw_rect.y;
        draw_rect.pad_rect_w = draw_rect.w;
        draw_rect.pad_rect_h = draw_rect.h;
    }
}