/// @description here
function yui_sort_struct_array(struct_array, struct_key_name) {
	
	var count = array_length(struct_array)
	
	// map the array based on the selected value;
	var map = {};
	var i = 0; repeat count {
		var struct = struct_array[i++];
		var key = struct[$ struct_key_name];
		map[$ key] = struct;
	}
	
	// get the list of keys and sort it
	var sorted_keys = variable_struct_get_names(map)
	array_sort(sorted_keys, true);
	
	// recreate the array from the sorted key list
	var result = array_create(count);
	var i = 0; repeat count {
		result[i] = map[$ sorted_keys[i]];
		i++;
	}

	return result;
}