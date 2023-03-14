/// @description struct that can dynamically resolve a value from a single data path at runtime
function YuiBinding(path) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.path = path;
	
	if path != undefined {
		init(path);
	}
	
	static init = function(path) {
		
		// get a resolver for the path if we have one
		// NOTE: this is for derived Binding classes that may not pass a path
		if path != undefined {	
			if path == "" || path = " " {
				resolver = resolveEmptyPath;
			}
			else {
				var token_array = yui_string_split(path, ".");
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
		
		//// view_item resolution
		//view_resolver = undefined;
		
		//// todo string hash the type name
		//ancestor_type = value[$ "ancestor_type"];
		//if ancestor_type != undefined {
		//	view_resolver = resolveAncestorType;
		//}
	}
	
	static resolve = function YuiBinding_resolve(data_context, view_context) {
		//if view_resolver {
		//	// replace the data_context with the data_context from the resolved view item
		//	data_context = view_resolver(view_context);
		//}
		
		var data = resolver(data_context);
		
		return data;
	}
	
	static resolveEmptyPath = function YuiBinding_resolveEmptyPath(data) {
		return data;
	}
	
	static resolveToken = function YuiBinding_resolveToken(data) {
		if is_undefined(data) || is_string(data) {
			return undefined; // expecting struct but got undefined or string
		}
		return data[$ token];
	}
	
	static resolveTokenArray = function YuiBinding_resolveTokenArray(data) {
		
		if data == undefined {
			return undefined;
		}
		
		var i = 0; repeat array_length(tokens) {
			if is_string(data) {
				return undefined; // expecting struct but got string
			}
			
			var token = tokens[i++];
			data = data[$ token];
			if is_undefined(data) {
				return undefined; // field not found on struct
			}
		}
		return data;
	}
	
	static resolveAncestorType = function(view_context) {
		var data = undefined;
		var parent = view_context.parent; // assumes yui_base
		
		while data == undefined {
			// check if we ran out of parents
			if parent == undefined break;
			
			// check if we found it
			var parent_type = parent.yui_element.type; // TODO set this in yui_base
			if parent_type == ancestor_type {
				// NOTE: ignores 'data_source'!
				return parent.data_context; // assumes yui_base
			}
			
			// recurse up
			parent = parent.parent;
		}
		
		// if we got here we couldn't find the type
		throw yui_error("unable to find item for ancestor_type", ancestor_type);
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