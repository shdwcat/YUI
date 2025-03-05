/// @description here
function MxListExpression(item_exprs) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	
	self.item_exprs = item_exprs;
	self.count = array_length(item_exprs);
	
	static debug = function() {
		var list_items = array_create(count);
		var i = 0; repeat count {
			var expr = item_exprs[i];
			list_items[i] = expr.debug();
			i++;
		}
		
		return {
			_type: instanceof(self),
			list_items,
		}
	}
	
	// check if any of our items were live
	var is_live = false;
	var i = 0; repeat count {
		var expr = item_exprs[i++];
		is_live |= expr.is_yui_live_binding;
	}
	
	// we're only live if one or more items exprs was live
	if !is_live is_yui_live_binding = false;
	
	static resolve = function(data) {
		var result = array_create(count);
		
		var i = 0; repeat count {
			var expr = item_exprs[i];
			result[i] = expr.resolve(data);
			i++;
		}
		
		return result;
	}

}