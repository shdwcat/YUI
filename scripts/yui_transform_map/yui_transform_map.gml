/// @description transforms data by using the data as a key into the map from the transform props
function yui_transform_map(data, transform_props) {
	

	var mapped_value = transform_props.map[$ data];
	if is_undefined(mapped_value) {
		// TODO: add props.fallback_behavior option
		// if the mapping doesn't exist, return the data itself
		mapped_value = data;
	}
	
	return mapped_value;
}