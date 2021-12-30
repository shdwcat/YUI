/// @description
function YuiIndexBinding(left, index) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.left = left;
	self.index = index
	
	static resolve = function(data)
	{
		var left_val = yui_resolve_binding(left, data);
		
		if is_array(left_val) {
			var index_key = index.resolve(data);
			return left_val[index_key];
		}
		else if is_struct(left_val) {
			var index_key = index.resolve(data);
			return left_val[$ index_key];
		}
		else if left_val == undefined {
			throw yui_error("attempting to index an undefined value");
		}
		else {
			throw yui_error("cannot index value of type", typeof(left_val));
		}
	
	}
} 