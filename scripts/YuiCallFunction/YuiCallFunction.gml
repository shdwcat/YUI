/// @description Calls a function with bindable arguments
function YuiCallFunction(func_name, args) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	static is_call = true;
	
	static runtime_functions = gspl_get_runtime_function_map();
	
	self.func_name = func_name;
	self.args = args;
	self.arg_count = array_length(args);
	self.resolved_args = array_create(arg_count);	
		
	if is_instanceof(func_name, YuiIdentifier) {
		func_name = func_name.resolve();
		var script_index = asset_get_index(func_name);
		if script_index != -1 {
			// call script
			self.script_index = script_index;
			resolve = resolveScript;
		
		}
		else {
			// call runtime function
			function_index = runtime_functions[$ func_name];
					
			if function_index == undefined {
				yui_warning("could not find script or built-in function with name: " + func_name);
				return;
			}
		
			resolve = resolveRuntimeFunction;
		}
	}
	else if is_instanceof(func_name, YuiLambda) {
		resolve = resolveLambda;
	}
	else {
		// treat func_name as a binding (may be slot etc also) and resolve it
		resolve = resolveBoundFunction;
	}
	
	static resolveScript = function(data) {
			
		var i = 0; repeat arg_count {
			resolved_args[i] = args[i].resolve(data);
			i++;
		}
			
		return script_execute_ext(script_index, resolved_args);
	}
	
	static resolveRuntimeFunction = function(data) {

		var i = 0; repeat arg_count {
			resolved_args[i] = args[i].resolve(data);
			i++;
		}
			
		// NOTE: could hyperoptimize by setting .resolve based on the arg_count (which is already known)
		var a = resolved_args;
		switch arg_count {
			case 0: return function_index();
			case 1: return function_index(a[0]);
			case 2: return function_index(a[0], a[1]);
			case 3: return function_index(a[0], a[1], a[2]);
			case 4: return function_index(a[0], a[1], a[2], a[3]);
			case 5: return function_index(a[0], a[1], a[2], a[3], a[4]);
			case 6: return function_index(a[0], a[1], a[2], a[3], a[4], a[5]);
			case 7: return function_index(a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
			case 8: return function_index(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
			case 9: return function_index(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
			default:
				throw "can't call built in function with more than 9 arguments";
		}
	}
	
	static resolveLambda = function(data) {
		var i = 0; repeat arg_count {
			resolved_args[i] = args[i].resolve(data);
			i++;
		}
		
		return func_name.call(data, resolved_args);
	}
	
	static resolveBoundFunction = function(data) {
		
		// resolve the function reference and arguments
		var func_ref = func_name.resolve(data);
		var i = 0; repeat arg_count {
			resolved_args[i] = args[i].resolve(data);
			i++;
		}
			
		if func_ref == undefined {
			yui_warning("can't call undefined function reference");
			return;
		}
		
		// handle calling arrays
		if is_array(func_ref) {
			return yui_call_handler(func_ref, resolved_args, data);
		}
		
		if is_instanceof(func_ref, YuiLambda) {
			return func_ref.call(data, resolved_args);
		}

		// NOTE: could hyperoptimize by setting .resolve based on the arg_count (which is already known)
		var a = resolved_args;
		switch arg_count {
			case 0: return func_ref();
			case 1: return func_ref(a[0]);
			case 2: return func_ref(a[0], a[1]);
			case 3: return func_ref(a[0], a[1], a[2]);
			case 4: return func_ref(a[0], a[1], a[2], a[3]);
			case 5: return func_ref(a[0], a[1], a[2], a[3], a[4]);
			case 6: return func_ref(a[0], a[1], a[2], a[3], a[4], a[5]);
			case 7: return func_ref(a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
			case 8: return func_ref(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
			case 9: return func_ref(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
			default:
				throw "can't call method with more than 9 arguments";
		}
	}
	
	static compile = function() {
		
		if is_string(func_name) {
			var call = func_name;
		}
		else if is_instanceof(func_name, YuiIdentifier) {
			// needs special handling until I can fix how function names work...
			var call = func_name.identifier;
		}
		else if is_instanceof(func_name, YuiLambda) {
			// needs special handling until I can fix how function names work...
			var call = func_name.compiled_script_name;
		}
		else {
			var call = func_name.compile();
		}
		
		call += "(";
		
		if is_instanceof(func_name, YuiLambda) {
			call += "data, ";
		}
		
		var i = 0; repeat arg_count {
			call += args[i].compile();
			i++;
			if i != arg_count {
				call += ", ";
			}
		}
		call += ")";
		
		return call;
	}
}