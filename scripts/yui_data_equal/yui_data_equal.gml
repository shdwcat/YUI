// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function yui_data_equal(first, second) {
	
	if is_method(first) || is_method(second) {
		return false;
	}
	
	if typeof(first) == "method" || typeof(second) == "method" {
		return false;
	}
		
	var names1 = variable_struct_get_names(first);
	var names2 = variable_struct_get_names(second);
	var count1 = array_length(names1);
	var count2 = array_length(names2);
	
	if count1 != count2
		return false;
	
	var i = 0; repeat count1 {
		var key = names1[i++];
		var value1 = first[$key];
		var value2 = second[$key];
		
		if is_array(value1) {
			if !array_equals(value1, value2)
				return false;			
		}
		else {
			if value1 != value2
				return false;
		}			
	}

	return true;
}