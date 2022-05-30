/// @description returns whether or not the array contains the value
function yui_array_contains(array, value) {
	
	var i = 0; repeat array_length(array) {
		if array[i++] == value {
			return true;
		}
	}
	
	return false;
}
