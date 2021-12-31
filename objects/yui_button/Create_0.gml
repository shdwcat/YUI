/// @description

// Inherit the parent event
event_inherited();

button_pressed = false;

// safely override border layout init
border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	highlight_color = layout_props.highlight_color;
}

left_pressed = function() {
	// scoop this up to prevent drag drop initiation through buttons
}

left_click = function() {
	yui_handle_event(yui_element.props.on_click, data_context, self);
}

cursor_hover = function() {
	//
}