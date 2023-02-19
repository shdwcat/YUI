/// @description here
function AnimationExampleData() constructor {
	
	id = "anim_example_data";
	
	var all_curves = yui_get_asset_list(animcurve_exists, animcurve_get);
	
	var valid_curves = array_filter(all_curves, function(c) { return array_length(c.channels) == 1; });
	
	curve_list = yui_sort_struct_array(valid_curves, "name");
	
	selected_curve = array_length(curve_list) > 0 ? curve_list[0] : undefined;
	
	from = 100;
	to = 0;
	duration = 1000;
	delay = 0;
	
	repeats = false;
	has_step = false;
	step = undefined;
	time_step = undefined;
	
	from_error = undefined;

}