/// @description takes a string and a delimiter and splits the string into an array by the delimeter
/// @param {string} string the string to split
/// @param {string} delim the delimiter that separated tokens
/// @param {real} [count] max number of tokens to return
function yui_string_split(str, delim, count = 0) {
	
	var pos = 1;
	
	var new_pos = string_pos_ext(delim, str, pos);
	
	// if we didn't find it, return the whole string as the first token
	if new_pos == 0 return [str];
	
	// otherwise, fill out the array with tokens as we find them
	var tokens = [];
	var i = 0;
	do {
		// early out if we've reached the [optional] max token count
		if i + 1 == count {	
			tokens[i] = string_copy(str, pos, string_length(str) - pos + 1);	
			return tokens;
		}
		
		tokens[i++] = string_copy(str, pos, new_pos - pos);	
		
		pos = new_pos + string_length(delim);
		new_pos = string_pos_ext(delim, str, pos);
	}
	until new_pos == 0;
	tokens[i++] = string_copy(str, pos, string_length(str) - pos + string_length(delim));
	
	return tokens;
}