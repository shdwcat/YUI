/// @description
function YuiSetValue(left, name, right) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	static is_call = true;
	static is_assign = true;
	
	self.left = left;
	self.name = name;
	self.right = right;
	
	static resolve = function(data) {
		var right_val = right.resolve(data);
		var left_val = left.resolve(data);
		
		// set the value
		variable_struct_set(left_val, name, right_val);
	}

	static compile = function()
	{
		return "var target = " + left.compile() + "\n"
			+ "\ttarget." + name + " = " + right.compile();
	}
}