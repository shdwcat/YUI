/// @description here
function YuiInstanceProvider(props) constructor {
	object_type = asset_get_index(props.object_type);
	
	if asset_get_type(props.object_type) != asset_object {
		yui_warning("object_type must be an object asset name");
	}
	
	static getDataSource = function() {
		var source = instance_find(object_type, 0);
		return source;
	}
}