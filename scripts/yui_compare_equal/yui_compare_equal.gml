// MultiBinding transform
/// @description return strue if all values are equal
function yui_compare_equal(values) {
	var value = values[0];
	
	var i = 1; repeat array_length(values) - 1 {
		var compare_value = values[i++];
		if compare_value != value {
			return false;
		}
	}
	
	return true;
}