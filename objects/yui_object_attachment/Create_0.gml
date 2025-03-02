/// @description init

// Inherit the parent event
event_inherited();

placement = undefined;

onLayoutInit = function() {	
	target_value = new YuiBindableValue(yui_element.target, undefined);
	placement = yui_element.placement;
}

alignToTarget = function(target) {
	
	switch placement {
		case YUI_PLACEMENT_MODE.TopLeft:
			yui_align_relative(target, fa_left, fa_top);
			break;
		case YUI_PLACEMENT_MODE.TopCenter:
			yui_align_relative(target, fa_center, fa_top);
			break;
		case YUI_PLACEMENT_MODE.TopRight:
			yui_align_relative(target, fa_right, fa_top);
			break;
		
		// todo actually support these -- need to figure out how tho
		case YUI_PLACEMENT_MODE.LeftTop:
			yui_align_relative(target, fa_right, fa_top);
			break;
		case YUI_PLACEMENT_MODE.RightTop:
			yui_align_relative(target, fa_left, fa_top);
			break;
		
		case YUI_PLACEMENT_MODE.BottomLeft:
			yui_align_relative(target, fa_left, fa_bottom);
			break;
		case YUI_PLACEMENT_MODE.BottomCenter:
			yui_align_relative(target, fa_center, fa_bottom);
			break;
		case YUI_PLACEMENT_MODE.BottomRight:
			yui_align_relative(target, fa_right, fa_bottom);
			break;
	}
	
	if content_item && instance_exists(content_item) {
		var xdiff =  draw_size.x - content_item.draw_size.x;
		var ydiff =  draw_size.y - content_item.draw_size.y;
		content_item.move(xdiff, ydiff);
	}
}

border_arrange = arrange;
arrange = function(available_size, viewport_size) {
	var size = border_arrange(available_size, viewport_size);
	
	if target_value.is_live
		target_value.update(data_source);
		
	var target = target_value.value;
	if target != undefined && instance_exists(target)
		alignToTarget(target);
}

// override this to avoid notifying parent -- our size doesn't affect the parent
onChildLayoutComplete = function(child) {
	if !is_arranging {
		arrange(draw_rect, viewport_size);
	}
}