// credit to gleeson! modifications by shdwcat

function yui_draw_rect_outline(_x,_y,_width,_height,_thickness, color) {
    var _x2 = _x + _width - _thickness,
        _y2 = _y + _height - _thickness,
        _t  = _thickness;
		
	var old_color = draw_get_color();
	draw_set_color(color);
	
    draw_primitive_begin(pr_trianglestrip);
        draw_vertex(_x,_y);
        draw_vertex(_x2 + _t,_y);  draw_vertex(_x,_y + _t);   draw_vertex(_x2 + _t,_y + _t);  draw_vertex(_x2 + _t,_y);
        draw_vertex(_x2 + _t,_y2 + _t); draw_vertex(_x2,_y);  draw_vertex(_x2,_y2 + _t); draw_vertex(_x2 + _t,_y2 + _t);
        draw_vertex(_x,_y2 + _t);  draw_vertex(_x2 + _t,_y2); draw_vertex(_x,_y2);  draw_vertex(_x,_y2 + _t);
        draw_vertex(_x,_y);   draw_vertex(_x + _t,_y2 + _t);  draw_vertex(_x + _t,_y);   draw_vertex(_x,_y);
    draw_primitive_end();
	
	draw_set_color(old_color);
}