/// @description transforms data by using the data as a key into the map from the transform props
function yui_transform_map_with_cache(data, transform_props) {
	
	// set up the map if needed
	var map = transform_props[$ "map"];
	if map == undefined transform_props.map = {};
	
	// check for cached result
	var cached_data = transform_props.map[$ data]
	if is_undefined(cached_data) {
		// cache the transformed data using the script
		// TODO script params?
		var func = asset_get_index(transform_props.cache_script);
		cached_data = func(data);
		transform_props.map[$ data] = cached_data;
	}
	
	return cached_data;
}