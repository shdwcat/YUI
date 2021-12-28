/// @description here
function yui_resolve_padding(padding) {
	if padding == undefined padding = 0;
	
	var result = {};
	
	if is_numeric(padding) {
        result.left = padding;
        result.top = padding;
        result.right = padding;
        result.bottom = padding;
    }
    else if is_array(padding) {
        result.left = padding[0];
        result.top = padding[1];
            
        if array_length(padding) = 4 {
            result.right = padding[2];
            result.bottom = padding[3];
        }
        else {
            result.right = result.left;
            result.bottom = result.top;
        }
    }
		
	result.w = result.left + result.right;
	result.h = result.top + result.bottom;
	
	return result;
}