/// @description apply target position

if unloading {
	// if we have a parent and are not the unload root item, check if we can unload
	if parent != undefined && unload_root_item != self {
		// once the parent has destroyed itself we can unload ourselves as the
		// unload_root_item will be the one tracking the total unload anim time
		if !instance_exists(parent) {
			unload_now = true;
		}
	}
}

// destroy once we're done unloading
if unload_now {
	instance_destroy(self);
}

// applying this in pre-draw assures that all arrange() calls as
// a result of step logic will have been completed at this point

var xxv = xoffset_value;
var yxv = yoffset_value

if xxv.is_live xxv.update(data_source);
if yxv.is_live yxv.update(data_source);

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