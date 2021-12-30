/// @description
function YuiValueBinding(value, path) : YuiBinding(undefined) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true; // value is static but the value from the path might change
	
	self.value = value;
	self.path = path;
	
	if path == "" {
		resolver = resolveEmptyPath;
		is_yui_live_binding = false;
	}
	else if string_count(".", path) == 1 {
		resolver = resolveToken;
		token = path;
	}
	else {
		resolver = resolveTokenArray;
		tokens = yui_string_split(path, ".");
	}

	static resolve = function(data) {
		return resolver(value);
	}
}