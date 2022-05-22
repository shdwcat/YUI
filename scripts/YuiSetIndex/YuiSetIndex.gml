/// @description
function YuiSetIndex(left, index, right) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	static is_call = true;
	static is_assign = true;
	
	self.left = left;
	self.index = index;
	self.right = right;
	
	static resolve = function(data) {
		var right_val = right.resolve(data);
		var left_val = left.resolve(data);
		
		if is_array(left_val) {
			var index_val = index.resolve(data);
			left_val[index_val] = right_val;
		}
		else if left_val == undefined {
			throw yui_error("attempting to index an undefined value");
		}
		else {
			throw yui_error("cannot index value of type", typeof(left_val));
		}
	}
}

