/// @description here
function MxOptionalExpr(left, operation, source) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	
	self.check_value = left;
	self.operation = operation;
	self.source = source;
	
	static debug = function() {
		return {
			_type: instanceof(self),
			optional_value: check_value.debug(),
			operation: operation.debug(),
		}
	}
	
	static resolve = function(data) {
		var check = check_value.resolve(data);
		if check != undefined {
			return operation.resolve(data);
		}
	}
}