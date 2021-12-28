/// @description convert any binding expressions on the struct variables to YuiBindings
function yui_bind_array(array, resources, slot_values) {
	
	var i = 0; repeat array_length(array) {
		array[i] = yui_bind(array[i], resources, slot_values);
		i++;
	}
	
	return array;
}