/// @description
function WidgetGalleryData() constructor {
	check_state = false;
	selector_items = ["Windowed", "Borderless Test", "Fullscreen"];
	selected_index = 1;
	selected_item = selector_items[selected_index];
	
	// currently unused
	//switcher_selector = new YuiArraySelector(selector_items, selected_index)
	
	selected_list_item = "one";
	
	slider_value = 50;
	
	debug_overlay_visible = false;
	
	editable_text = "placeholder text";
	
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
				new YuiMenuItem("Test 1", , function() {
					// TODO?
				}),
				new YuiMenuItem("Test 2", , function() {
					// TODO?
				}),
			]),
		]),
	];
}