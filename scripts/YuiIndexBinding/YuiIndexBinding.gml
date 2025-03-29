/// @description
function YuiIndexBinding(left, index) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	
	self.left = left;
	self.index = index
	
	static debug = function() {
		return {
			_type: instanceof(self),
			left: left.debug(),
			index: index.debug(),
		}
	}
	
	static resolve = function(data)
	{
		var left_val = left.resolve(data);
		
		if is_array(left_val) {
			var index_key = index.resolve(data);
			if index_key >= array_length(left_val)
				throw yui_error($"attempted to retrieve index {index_key} from array with length {array_length(left_val)}");
			
			return index_key != undefined ? left_val[index_key] : undefined;
		}
		else if is_struct(left_val) {
			var index_key = index.resolve(data);
			return index_key != undefined ? left_val[$ index_key] : undefined;
		}
		else if left_val == undefined {
			var left_type = instanceof(left);
			throw yui_error("attempting to index an undefined value from expression of type: " + left_type);
		}
		else {
			throw yui_error("cannot index value of type", typeof(left_val));
		}
	}
	
	static compile = function() {
		// assume struct 🤷‍
		return left.compile() + "[$ " + index.compile() + "]";
	}
} 