/// @description determines whether a struct is a type of YUI Binding expression
function yui_is_binding_expr(binding) {
	
	if is_string(binding) {
		switch string_char_at(binding, 1) {
			case "@":
			case "$":
			case "&":
				return true;
		}
	}
	
	return false;
}