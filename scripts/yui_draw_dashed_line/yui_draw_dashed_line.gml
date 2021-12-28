/// @description draws a dashed line between two points
function yui_draw_dashed_line(x1, y1, x2, y2, width = 1, dash_length = 16, color = c_white) {
	// adapted from here:
	// https://steamcommunity.com/app/214850/discussions/0/357284131800752330/
		
	var len = point_distance(x1,y1,x2,y2) div dash_length;
	var dir = point_direction(x1,y1,x2,y2);
	var a = lengthdir_x(dash_length, dir);
	var b = lengthdir_y(dash_length, dir);
	
	for (var i=0; i<len; i++) {
		if !(i & 1)
		{
			var _x1 = x1+a*i;
			var _y1 = y1+b*i;
			var _x2 = x1+a*(i+1);
			var _y2 = y1+b*(i+1);
			draw_line_width_color(_x1, _y1, _x2, _y2, width, color, color);
		}
	}
}