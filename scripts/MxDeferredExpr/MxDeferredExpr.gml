/// @description see YsDirectiveParselet 'defer' directive
function MxDeferredExpr(expr) : YuiExpr() constructor {
	self.expr = expr;
	static is_yui_live_binding = true;

	static resolve = function(data) {
		return expr;
	}
}