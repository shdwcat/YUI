/// @description here
function AnimationPropertyData(from = 0, to = 100) constructor {
	
	id = "anim_prop_data";
		
	static valid_curves = array_filter(
		yui_get_asset_list(animcurve_exists, animcurve_get),
		function(c) { return array_length(c.channels) == 1; });
	
	curve_list = yui_sort_struct_array(valid_curves, "name");
	
	selected_curve = array_length(curve_list) > 0 ? curve_list[0] : undefined;
	
	self.from = from;
	self.to = to;
	duration = 1000;
	delay = 0;
	
	repeats = false;
	has_step = false;
	step = undefined;
	time_step = undefined;
	
	from_error = undefined;
	
	expanded = true;

}