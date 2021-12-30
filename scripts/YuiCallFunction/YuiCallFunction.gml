/// @description Calls a function with bindable arguments
function YuiCallFunction(func_name, args) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	static runtime_functions = gspl_get_runtime_function_map();
	
	self.func_name = func_name;
	self.args = args;
	self.arg_count = array_length(args);
	
	var script_index = asset_get_index(func_name);
	if script_index != -1 {
		// call script
		self.script_index = script_index;
		resolve = function(data) {
			
			resolved_args = array_create(arg_count);
			var i = 0; repeat arg_count {
				resolved_args[i] = args[i].resolve(data);
				i++;
			}
			
			return script_execute_ext(script_index, resolved_args);
		}
		
	}
	else {
		// call runtime function
		function_index = runtime_functions[$ func_name];
		
		resolve = function(data) {
			
			resolved_args = array_create(arg_count);
			var i = 0; repeat arg_count {
				resolved_args[i] = args[i].resolve(data);
				i++;
			}
			
			// NOTE: could hyperoptimize by setting .resolve based on the arg_count (which is already known)
			var a = resolved_args;
			switch array_length(a) {
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
	}
	
	
	
}