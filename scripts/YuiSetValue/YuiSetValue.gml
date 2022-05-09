/// @description
function YuiSetValue(left, name, right) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.left = left;
	self.name = name;
	self.right = right;
	
	static resolve = function(data) {
		var right_val = right.resolve(data);
		var left_val = left.resolve(data);
		
		// set the value
		variable_struct_set(left_val, name, right_val);
	}
}