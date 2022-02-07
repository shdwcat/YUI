/// @description
function WidgetGalleryData() constructor {
	check_state = false;
	switcher_items = ["Windowed", "Borderless", "Fullscreen"];
	
	switcher_selector = new YuiArraySelector(switcher_items, switcher_items[1])
	
	slider_value = 50;
}