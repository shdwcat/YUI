/// @description

var overlay = new InspectronOverlay()
	.Pick(mouse_x, mouse_y, yui_game_item)
	.Pick(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), yui_base);
		
inspector.show(overlay.targets);