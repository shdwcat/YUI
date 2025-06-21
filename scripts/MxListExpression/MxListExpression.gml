/// @description here
function MxListExpression(item_exprs) : YuiExpr() constructor {

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
	self.is_yui_live_binding = is_live;

	static resolve = function(data) {
		var result = array_create(count);

		var skipped_any = false; // whether any empty spread exprs were found
		var result_index = 0;
		var result_count = count;
		var i = 0; repeat count {
			var expr = item_exprs[i++];

			// expand spread expressions
			if is_instanceof(expr, MxSpreadExpr) {
				var spread_items = expr.resolve(data);
				var spread_count = array_length(spread_items);

				if spread_count = 0 {
					skipped_any = true;
					result_count--;
				}
				else if spread_count > 1 {
					// increase the array size to account for the new items
					// TODO: could optimize by only resizing once we need space for the new items
					result_count += spread_count - 1;
					array_resize(result, result_count);

					// copy the spread item array into the result array
					array_copy(result, result_index, spread_items, 0, spread_count);

					// reposition to the new index
					result_index += spread_count;
				}
				else {
					result[result_index] = spread_items[0];
					result_index++;
				}

			}
			else {
				var expr_result = expr.resolve(data);
				result[result_index] = expr_result
				result_index++;
			}
		}

		if skipped_any
			array_resize(result, result_count);

		return result;
	}

}