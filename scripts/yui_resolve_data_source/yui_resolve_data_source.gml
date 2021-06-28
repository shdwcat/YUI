/// @description sets the data_context from a provided data_source
function yui_resolve_data_source(data_source, resources, trace) {
	if data_source == noone || is_undefined(data_source) return undefined;
	
	var source = data_source;
		
	if is_struct(source) {
		source = yui_bind(source, resources);
		
		if instanceof(source) == "YuiBinding" {
			source.trace = trace;
			return source;
		}
		
		// check if the data source is from resources
		var resource_id = source[$ "$resource"];
		if !is_undefined(resource_id) {	
			var source = resources[$ resource_id];
		}
		
		// check if it's a constructed data type
		var type = source[$ "$type"];
		if !is_undefined(type) {
			var source_provider = new YuiGlobals.datasource_map[$ type](source);
			source = source_provider.getDataSource();
		}
	}
	
	return source;
}