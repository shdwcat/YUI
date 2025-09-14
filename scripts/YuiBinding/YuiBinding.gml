/// @description struct that can dynamically resolve a value from a single data path at runtime
function YuiBinding(path) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	
	self.path = path;
	self.optional = false;
	
	if path != undefined {
		init(path);
	}
	
	static debug = function() {
		return {
			_type: instanceof(self),
			path,
		}
	}
	
	static init = function(path) {
		
		// get a resolver for the path if we have one
		// NOTE: this is for derived Binding classes that may not pass a path
		if path != undefined {	
			if path == "" || path = " " {
				resolver = resolveEmptyPath;
			}
			else {
				var token_array = string_split(path, ".");
				if array_length(token_array) == 1 {
					resolver = resolveToken;
					token = token_array[0];
				}
				else {
					resolver = resolveTokenArray;
					tokens = token_array;
				}
			}
		}
		else if is_instanceof(self, YuiBinding) {
			throw "YuiBinding initialized without a path!";
		}
	}
	
	// feather ignore once GM2017
	static resolve = function YuiBinding_resolve(data_context, view_context) {
		var data = resolver(data_context);
		return data;
	}
	
	// feather ignore once GM2017
	static resolveEmptyPath = function YuiBinding_resolveEmptyPath(data) {
		return data;
	}
	
	// feather ignore once GM2017
	static resolveToken = function YuiBinding_resolveToken(data) {
		if !optional {
			if data == undefined
				throw yui_error($"YuiBinding: 'data' was undefined, expected struct with key {token}");
			if !struct_exists(data, token)
				throw yui_error($"Could not find key '{token}' on item type {instanceof(data)}");
		}
		return data[$ token];
	}
	
	// feather ignore once GM2017
	static resolveTokenArray = function YuiBinding_resolveTokenArray(data) {
		
		if data == undefined {
			return undefined;
		}
		
		var result = data;
		var token = "@"; // this value only used for error messages
		
		var token_count = array_length(tokens);
		var i = 0; repeat token_count {
			if !is_struct(result) && !instance_exists(result)
				throw yui_error($"Expected struct or instance at '{token}' in path '{path}' (got {instanceof(result)})");
			
			var token = tokens[i++];
			result = result[$ token];
			
			if is_undefined(result) && i < token_count {
				throw yui_error($"Unable to get value for {token} in path '{path}' on item type {instanceof(data)}");
			}
		}
		
		return result;
	}
	
	static compile = function() {
		
		//switch resolver {
		//	case resolveEmptyPath:
		//		return "data";
				
		//	case resolveToken:
		//		return "data." + path;
		//		//"(data != undefined ? data." + path + " : undefined)";
				
		//	case resolveTokenArray:
		//		var compiled = "data != undefined";
		//		var token_path = "data";
				
		//		var i = 0; repeat array_length(tokens) {
		//			token_path += "." + tokens[i++];
		//			compiled += " && " + token_path + " != undefined";
		//		}
				
		//		compiled += " \n\t\t? " + token_path + " \n\t\t: undefined";
				
		//		return "(" + compiled + ")";
		//}
		
		return path = ""
			? "data"
			: "data." + path;
	}
}