/// @description a version of YuiBinding that binds to an object instead of the data context
function YuiObjectBinding(object_name_expr) constructor {
	static is_yui_binding = true;

	// expecting object_name_expr to be a literal that does not need data context
	var object_name = object_name_expr.resolve();

	// TODO: error on debug only
	if asset_get_type(object_name) != asset_object {
		throw yui_error(object_name," is not an object asset name");
	}
	
	self.object_index = asset_get_index(object_name);
	
	//with object_index {
	//	other.instance = self;
	//}
		
	resolve = function(data) {
		return object_index;
	}
}