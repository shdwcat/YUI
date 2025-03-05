/// @description base class for YuiScript expressions
function YuiExpr() constructor {
	static is_call = false;
	static is_lambda = false;
	static is_assign = false;
	static trace = false;
	
	static debug = function() {
		return {
			_type: instanceof(self),
		}
	}
	
	static checkType = function() {
		return undefined;
	}
	
	static compile = function() {
		return "NOT IMPLEMENTED";
	}
}