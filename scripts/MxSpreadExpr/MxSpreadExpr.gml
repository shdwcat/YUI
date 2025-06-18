/// @description here
function MxSpreadExpr(list_expr, source) : YuiExpr() constructor {
	self.list_expr = list_expr;
	self.source = source;
	self.is_yui_live_binding = list_expr.is_yui_live_binding;
	
	static debug = function() {
		return {
			_type: instanceof(self),
			list_expr: list_expr.debug(),
		}
	}
	
	static resolve = function(data) {
		var list = list_expr.resolve(data);
		if !is_array(list)
			throw yui_error("Spread operator (...) can only be applied to arrays");
		
		return list;
	}
}