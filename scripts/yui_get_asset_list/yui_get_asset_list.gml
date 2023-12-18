/// @description here
function yui_get_asset_list(asset_exists, asset_get) {
	var result = [];
	
	var i = 0;
	
	while asset_exists(i) {
		array_push(result, asset_get(i++));
	}
		
	return result;
}