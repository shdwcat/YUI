/// @description resolves any bindings in the elements of the arrat (not recursive)
function yui_resolve_array_bindings(array, data, view_item) {
	if !is_array(array) return array;
	
	var count = array_length(array);
	var resolved = array_create(count);
	
	var i = 0; repeat count {
		var value = array[i];
		array[i] = yui_resolve_binding(value, data, view_item);
		i++;
	}
	
	return resolved;
}