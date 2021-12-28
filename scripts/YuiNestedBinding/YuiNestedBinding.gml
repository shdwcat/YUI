/// @description resolves a binding against the result of another (possible) binding
function YuiNestedBinding(inner_binding, path) : YuiBinding(undefined, undefined, undefined) constructor {
	static is_yui_binding = true;
	
	self.inner_binding = inner_binding;
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
		var inner_result = inner_binding.resolve(data);
		return resolver(inner_result);
	}
}