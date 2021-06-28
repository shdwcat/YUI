/// @description creates a YuiBinding if the value is bindable
function yui_bind(value, resources) {
	
	// if it's not a struct, just return it
	if !is_struct(value) return value;
	
	var path = value[$ "$path"];
	
	// back compat
	if path == undefined {
		//value[$ "$path"] = value[$ "path"]
		path = value[$ "path"];
	}	
	
	if is_string(path) {				
		return new YuiBinding(value, resources);
	}
	else if is_array(path) {
		// TODO: maybe this should chind for value.$multibind or something?
		return new YuiMultiBinding(value, resources);
	}
	else {
		// if it's a struct but doesn't have $path, just return it
		return value;
				
		// TODO: (optionally) recursively check for bindings inside the struct
		// to handle things like size: { w: { path: foo }}, where we want size to be bindable
		// and size.w to be bindable
		
	}
}

function YuiBinding(value, resources) constructor {
	
	static init = function(value, resources) {
		var path = value[$ "path"];
		transform = value[$ "transform"];
		if transform != undefined {
			transform = yui_resolve_transform(transform, resources);
		}
	
		if path == "" || path == "$data" {
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
		
		fallback_value = value[$ "fallback"];
		if fallback_value == undefined {
			fallback_value = noone;
		}
				
		var _then = value[$ "then"];
		var _else = value[$ "else"];
		
		equals = value[$ "equals"];
		if equals != undefined {
			true_value = _then != undefined ? _then : true;
			false_value = _else != undefined ? _else : false;
		}
		
		is_not = value[$ "is_not"];
		if is_not != undefined {
			true_value = _then != undefined ? _then : true;
			false_value = _else != undefined ? _else : false;
		}
		
		is_none = value[$ "is_none"];
		if is_none != undefined {
			true_value = _then != undefined ? _then : true;
			false_value = _else != undefined ? _else : false;
		}
	}
	
	static resolve = function(data_context, resources) {
		var data = resolver(data_context);
		
		if transform != undefined {
			if is_struct(transform) {
				if data == undefined {
					yui_error("can't apply transform to undefined data");
				}
				else {
					data = transform.transform_function(data, transform.transform_props);
				}
			}
			else  {
				data = transform(data);
			}
		}
						
		if equals != undefined {			
			data = data == equals ? true_value : false_value;			
		}
		else if is_not != undefined {
			data = data != is_not ? true_value : false_value;
		}
		else if is_none != undefined {
			data = (data == undefined || data == noone) == is_none ? true_value : false_value;
		}
		
		return data;
	}
	
	static resolveEmptyPath = function(data) {
		return data;
	}
	
	static resolveToken = function(data) {
		if is_undefined(data) || is_string(data) {
			return fallback_value; // expecting struct but got undefined or string
		}
		return data[$ token];
	}
	
	static resolveTokenArray = function(data) {
		var i = 0; repeat array_length(tokens) {		
			if is_string(data) {
				return fallback_value; // expecting struct but got string
			}
			
			var token = tokens[i++];
			data = data[$ token];
			if is_undefined(data) {
				return fallback_value; // field not found on struct
			}
		}
		return data;
	}
	
	init(value, resources);
}
	
function YuiMultiBinding(value, resources) constructor {
	
	static init = function(value, resources) {
		var paths = value[$ "path"];
		var i = 0; repeat array_length(paths) {
			var path = paths[i];
			var temp = {};
			temp[$ "path"] = path;
						
			bindings[i] = new YuiBinding(temp, resources)
			i++;
		}
		
		transform = value[$ "transform"];
		if transform != undefined {
			transform = yui_resolve_transform(transform, resources);
		}
	}
	
	static resolve = function(data_context, resources) {
		var count = array_length(bindings)
		
		// resolve the bindings to the result array for the current data
		var result = array_create(count);
		var i = 0; repeat count {
			result[@ i] = bindings[i].resolve(data_context, resources);
			i++;
		}
		
		// apply transform
		if transform != undefined {
			if is_struct(transform) {
				result = transform.transform_function(result, transform.transform_props);				
			}
			else  {
				result = transform(result);
			}
		}
		
		return result;
	}
	
	init(value, resources);
}