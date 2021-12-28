/// @description
function YuiValueBinding(resource, path) : YuiBinding(undefined, undefined, undefined) constructor {
	static is_yui_binding = true;
	
	self.resource = resource;
	self.path = path;
	
	if path == "" {
		resolver = resolveEmptyPath;
	}
	else if string_pos(",", path) > 0 {
		resolver = resolveToken;
		token = path;
	}
	else {
		resolver = resolveTokenArray;
		tokens = yui_string_split(path, ".");
	}

	static resolve = function(data) {
		return resolver(resource);
	}
}