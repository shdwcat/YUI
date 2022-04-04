/// @description
function WidgetGalleryData() constructor {
	check_state = false;
	switcher_items = ["Windowed", "Borderless", "Fullscreen"];
	
	switcher_selector = new YuiArraySelector(switcher_items, switcher_items[1])
	
	slider_value = 50;
	
	debug_overlay_visible = false;
	
	menu = [
		new YuiTopMenu("Debug", , [
			new YuiMenuItemCheckable("Show Debug Overlay", , function(show) {
				show_debug_overlay(show);
			}, debug_overlay_visible),
		]),
		new YuiTopMenu("Map", , [
			new YuiMenuItem("Save", , function() {
				// TODO?
			}),
			new YuiSubMenu("SubMenu Test", , [
				new YuiMenuItem("Test", , function() {
					// TODO?
				}),
			]),
		]),
	];
}