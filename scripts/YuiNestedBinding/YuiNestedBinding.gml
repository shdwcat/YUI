/// @description resolves a binding against the result of another (possible) binding
function YuiNestedBinding(inner_binding, path) : YuiBinding(undefined) constructor {
	static is_yui_live_binding = true; // check if inner_binding is live?
	
	self.inner_binding = inner_binding;
	self.path = path;
	
	static debug = function() {
		return {
			_type: instanceof(self),
			path,
			inner_binding: inner_binding.debug(),
		}
	}
	
	if path == "" {
		resolver = resolveEmptyPath;
	}
	else if string_count(".", path) == 0 {
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
	
	static compile = function() {
		return path == ""
			? inner_binding.compile()
			: inner_binding.compile() + "." + path;
	}
}