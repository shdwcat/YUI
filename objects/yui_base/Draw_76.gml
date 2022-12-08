/// @description apply target position

// applying this in pre-draw assures that all arrange() calls as
// a result of step logic will have been completed at this point

var xoffset_changed = xoffset_value.update(data_source);
var yoffset_changed = yoffset_value.update(data_source);

// TODO compute target_x/y from parent and relative placement

x = target_x + xoffset_value.value;
y = target_y + yoffset_value.value;

if xoffset_changed {
	draw_size.x = x;
	draw_rect.x = x;
	padded_rect.x = x;
}

if yoffset_changed {
	draw_size.y = y;
	draw_rect.y = y;
	padded_rect.y = y;
}


// TODO update viewport here?