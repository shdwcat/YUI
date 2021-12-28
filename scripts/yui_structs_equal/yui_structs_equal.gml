/// @description checks if two structs are equal (and recursively checks nested structs)
function yui_structs_equal(first, second) {
	
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
			//if !yui_arrays_equal(value1, value2)
				return false;			
		}
		else if is_method(value1) {
			// methods are structs so we have to short circuit before the recursive struct_equals
			if value1 != value2
				return false;
		}
		else if is_struct(value1) && instanceof(value1) == "struct" {
			// only recursively check into structs that are *not* from constructors
			// (i.e. not scribble structs)
			if !yui_structs_equal(value1, value2)
				return false;
		}
		else {
			if value1 != value2
				return false;
		}			
	}

	return true;
}