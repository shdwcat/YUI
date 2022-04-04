/// @description
function yui_array_find_index(array, value) {
    
	var i = 0; repeat(array_length(array))
    {
        if (array[i] == value) return i;
        ++i;
    }
    
    return -1;
}