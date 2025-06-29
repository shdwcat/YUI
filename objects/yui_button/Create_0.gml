/// @description

// Inherit the parent event
event_inherited();

button_pressed = false;

click_sound_id = undefined;

// safely override border layout init
border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	highlight_color = layout_props.highlight_color;
	highlight_alpha = layout_props.highlight_alpha;
	pressed_alpha = layout_props.pressed_alpha;
}

left_pressed = function() {
	// scoop this up to prevent drag drop initiation through buttons
}

left_click = function() {
	// NOTE: generally this will get overwritten by yui_register_events() as long
	// as a click event is defined, but if for some reason we want a button without
	// a click handler, this ensures that it still behaves like a button by consuming
	// the event and otherwise doing normal button behavior.
	
	if !enabled return;
	
	focus();
	
	click_sound_id = playSound("click", click_sound_id);
}

cursor_hover = function() {
	//
}