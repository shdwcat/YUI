// NOTE: unsafe function calls will not be supported in the future
#macro YUI_ALLOW_UNSAFE_FUNCTION_CALLS false

/// @description Calls a function with bindable arguments
function YuiCallFunction(target_expr, args) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	static is_call = true;
	
	static runtime_functions = gspl_get_runtime_function_map();
	
	self.target_expr = target_expr;
	self.args = args;
	self.arg_count = array_length(args);
	self.resolved_args = array_create(arg_count);
	
	static debug = function() {
		var args_list = array_create(arg_count);
		var i = 0; repeat arg_count {
			var expr = args[i];
			args_list[i] = expr.debug();
			i++;
		}
		
		return {
			_type: instanceof(self),
			call_target: is_instanceof(target_expr, YuiExpr) ? target_expr.debug() : target_expr,
			args: args_list,
		}
	}

	if is_instanceof(target_expr, YuiAssetReference) {
		var target = target_expr.resolve();
		if !is_callable(target) {
			throw yui_error($"YuiCallFunction: Target is not callable");
		}
		
		if target_expr.is_runtime_function {
			function_index = target;
			resolve = resolveRuntimeFunction;
		}
		else {
			// script
			self.script_index = target;
			resolve = resolveScript;
		}
	}
	else if is_instanceof(target_expr, YuiIdentifier) {
		var target_name = target_expr.resolve();
		
		var error = yui_error($"Use ~{target_name} to refer to GML functions or scripts, or set YUI_ALLOW_UNSAFE_FUNCTION_CALLS macro to true (in expression '{target_expr.source}')");
		if !YUI_ALLOW_UNSAFE_FUNCTION_CALLS {
			throw error;
		}
		
		
		var script_index = asset_get_index(target_name);
		if script_index != -1 {
			// call script
			self.script_index = script_index;
			resolve = resolveScript;
			yui_log_asset_use(target_name, "!! script", target_expr.source);
		}
		else {
			// call runtime function
			function_index = runtime_functions[$ target_name];
					
			if function_index == undefined {
				yui_warning("could not find script or built-in function with name: " + target_name);
				resolve = function() { return undefined };
				return;
			}
		
			resolve = resolveRuntimeFunction;
			yui_log_asset_use(target_name, "!! GML Runtime Function", target_expr.source);
		}
	}
	else if yui_is_lambda(target_expr) {
		resolve = resolveLambda;
	}
	else {
		// treat target_expr as a binding (may be slot etc also) and resolve it
		resolve = resolveBoundFunction;
	}
	
	static resolveScript = function(data) {
			
		var i = 0; repeat arg_count {
			resolved_args[i] = yui_resolve_binding(args[i], data);
			i++;
		}
			
		return script_execute_ext(script_index, resolved_args);
	}
	
	static resolveRuntimeFunction = function(data) {

		var i = 0; repeat arg_count {
			resolved_args[i] = yui_resolve_binding(args[i], data);
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
			resolved_args[i] = yui_resolve_binding(args[i], data);
			i++;
		}
		
		return target_expr.call(data, resolved_args);
	}
	
	static resolveBoundFunction = function(data) {
		
		// resolve the function reference and arguments
		var func_ref = target_expr.resolve(data);
		var i = 0; repeat arg_count {
			resolved_args[i] = yui_resolve_binding(args[i], data);
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
		
		if !is_method(func_ref)
			throw yui_error($"Cannot call expression value with type {typeof(func_ref)} as a function");

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
		
		if is_string(target_expr) {
			var call = target_expr;
		}
		else if is_instanceof(target_expr, YuiIdentifier) {
			// needs special handling until I can fix how function names work...
			var call = target_expr.identifier;
		}
		else if is_instanceof(target_expr, YuiLambda) {
			// needs special handling until I can fix how function names work...
			var call = target_expr.compiled_script_name;
		}
		else {
			var call = target_expr.compile();
		}
		
		call += "(";
		
		if is_instanceof(target_expr, YuiLambda) {
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