/// @description 

// Inherit the parent event
event_inherited();

is_popup_visible = false;
popup_item = undefined;

// do we need to override build?

button_arrange = arrange;
arrange = function(available_size, viewport_size) {
	var size = button_arrange(available_size, viewport_size);
	return size;
}

border_move = move;
move = function(xoffset, yoffset) {
	border_move(xoffset, yoffset);
	if popup_item {
		var popup_space = yui_calc_popup_space(popup_item);
	}
}

left_click = function() {
	
	if !bound_values.enabled return;
	
	// TODO do we need to call base?
	// only if we support on_click in addition to popup toggle
	
	is_popup_visible = !is_popup_visible;
	if is_popup_visible {	
		openPopup();
	}
	else {
		instance_destroy(popup_item);
		popup_item = undefined;
	}
}

openPopup = function() {
	is_popup_visible = true;
	
	// make sure we don't orphan an existing item
	if popup_item {
		instance_destroy(popup_item);
	}
		
	// find any open popups and close them, unless they're a parent of this button
	var parent_map = yui_get_item_parent_map(self);
	with yui_popup {
		var button = parent;
		if !ds_map_exists(parent_map, button)
		{
			button.closePopup();
		}
	}
	ds_map_destroy(parent_map);
	
	// open the popup
	
	popup_item = yui_make_render_instance(bound_values.popup_element, bound_values.data_source, , 100);
	
	positionPopup(popup_item.bound_values.placement, popup_item.parent.draw_size);
}

positionPopup = function(placement, parent_size) {
	if popup_item && instance_exists(popup_item) {
		var popup_space = yui_calc_popup_space(placement, parent_size);
		popup_item.arrange(popup_space);
	}
}

closePopup = function(close_parent = false) {
	is_popup_visible = false;
	
	if popup_item {
		instance_destroy(popup_item);
		popup_item = undefined;
	}
	
	if parent && close_parent {
		parent.closePopup(true);
	}
}


