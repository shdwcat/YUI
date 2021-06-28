// credit to Sahuan!

/// @func yui_draw_polygon_outline(sides, x, y, radius, width)
function yui_draw_polygon_outline(_sides, _x, _y, _radius, _width) {
    _width /= 2;
    var _inc = 360/_sides, _angle = 0;
    draw_primitive_begin(pr_trianglestrip);
    repeat(_sides+1) {
        draw_vertex(_x+lengthdir_x(_radius-_width,_angle), _y+lengthdir_y(_radius-_width,_angle));
        draw_vertex(_x+lengthdir_x(_radius+_width,_angle), _y+lengthdir_y(_radius+_width,_angle));
        _angle += _inc;
    }
    draw_primitive_end();
}