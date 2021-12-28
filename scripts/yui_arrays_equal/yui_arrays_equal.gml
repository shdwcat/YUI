/// @description checks if two arrays are equal (TODO: nested arrays/structs)
function yui_arrays_equal(first, second) {
	
	var count1 = array_length(first);
	var count2 = array_length(second);
	
	if count1 != count2
		return false;
	
	var i = 0; repeat count1 {
		var value1 = first[i];
		var value2 = second[i];
		
		if is_array(value1) {
			if !yui_arrays_equal(value1, value2)
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
		
		i++;
	}
	
	return true;
}