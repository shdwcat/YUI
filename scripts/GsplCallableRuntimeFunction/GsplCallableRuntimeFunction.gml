/// @description wraps a runtime function in a GsplCallable
function GsplCallableRuntimeFunction(function_index) : GsplCallable() constructor {
	self.function_index = function_index;
	
	static arity = function() {
		return undefined;
	}

	static call = function(interpreter, args) {		
		try {
			// can't use script_execute_ext on built-in functions, but we can just call the function_index
			var a = args;
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
		catch (error) {
			gspl_log("error calling runtime function: " + string(error));
			throw error;
		}
	}
}