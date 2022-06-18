/// @description
function gspl_string_substring(source_string, start_pos, end_pos = undefined) {
	
	end_pos ??= string_length(source_string) + 1;
	
	return string_copy(source_string, start_pos, end_pos - start_pos);
}