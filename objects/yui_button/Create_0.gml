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
	if !bound_values.enabled return;
	if yui_element.props.on_click != undefined {
		var element = self;
		var args = {
			source: element,
			button: "left",
		};
		// NOTE: doesn't support data_source yet
		yui_call_handler(yui_element.props.on_click, [args], data_context, element);
	}
}

cursor_hover = function() {
	//
}