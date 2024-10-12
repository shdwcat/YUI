/// @description a version of YuiBinding that binds to an object instead of the data context
function YuiObjectBinding(object_name_expr) : YuiExpr() constructor {
	static is_yui_live_binding = false;

	// expecting object_name_expr to be a literal that does not need data context
	var object_name = object_name_expr.resolve();

	// TODO: error on debug only
	if asset_get_type(object_name) != asset_object {
		throw yui_error(object_name," is not an object asset name");
	}
	
	self.object_index = asset_get_index(object_name);
	
	if self.object_index == -1 {
		throw yui_error("Could not find object with name", object_name);
	}
		
	resolve = function(data) {
		return object_index;
	}
}