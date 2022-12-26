/// @description apply target position

// applying this in pre-draw assures that all arrange() calls as
// a result of step logic will have been completed at this point

var xxv = xoffset_value;
var yxv = yoffset_value

xxv.update(data_source);
yxv.update(data_source);

if parent {
	xoffset = xxv.value + parent.xoffset;
	yoffset = yxv.value + parent.yoffset;
}
else {
	xoffset = xxv.value;
	yoffset = yxv.value;
}

if xoffset != 0
	x = draw_size.x + xoffset;
	
if yoffset != 0
	y = draw_size.y + yoffset;