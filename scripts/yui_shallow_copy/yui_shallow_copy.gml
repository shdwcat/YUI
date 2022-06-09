/// @description copies the values of a struct to a new struct
function yui_shallow_copy(source) {
	var result = {};
	var keys = variable_struct_get_names(source);
	var i = 0; repeat array_length(keys) {
		var key = keys[i++];
		result[$ key] = source[$ key];
	}
	return result;
}