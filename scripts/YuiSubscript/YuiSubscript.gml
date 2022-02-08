/// @description access a single variable from a source, e.g. foo.bar
function YuiSubscript(expr, variable_name) constructor {	
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.expr = expr;
	self.variable_name = variable_name;
	
	static resolve = function(data) {
		var struct = expr.resolve(data);
		return variable_struct_get(struct, variable_name);
	}

}