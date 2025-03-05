/// @description
function YuiValueBinding(value, path) : YuiBinding(undefined) constructor {
	static is_yui_live_binding = true; // value is static but the value from the path might change
	
	self.value = value;
	self.path = path;
	
	static debug = function() {
		return {
			_type: instanceof(self),
			value: is_struct(value) ? instanceof(value) : value, // avoid tostring on structs
			path,
		}
	}
	
	if path == "" {
		resolver = resolveEmptyPath;
		self.is_yui_live_binding = false;
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
		return resolver(value);
	}
	
	static compile = function() {
		// ignores live values
		
		// if value is a struct, we essentially want to create a shared struct declaration
		// in the compiled file, then return a reference to that and apply the YuiBinding
		// compilation to it.
		
		// the problem is uniquely ID'ing the struct.
		// I think the way to do is to move 'state' slots into a dedicated `state` field on 
		// the template, and then in the template constructor you'd get a unique ID from the 
		// elememnt ID + the state slot name.
		// I'd then need to be able to instantiate those structs when requested, or pull from
		// the existing one if its already created for the ID.
		
		// or state could go in a dedicated value on the element, and add a `state` keyword to
		// access it. Then we don't need to do fancy state compilation.
		
		return string(resolver(value));
	}
}