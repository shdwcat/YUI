/// @description resolves a value from a struct via a potentially-nested field path
/// @param binding - either a binding struct or the raw value
/// @param data_context - the data to resolve the binding against
/// @param resources - the resources for the yui_document, for transforms and such
function yui_resolve_binding(binding, data_context, resources) {
	
	if instanceof(binding) == "YuiBinding" {
		return binding.resolve(data_context, resources);
	}
	
	var is_binding = is_struct(binding) && variable_struct_exists(binding, "path");
	
	// if the 'binding value' is not a binding struct, just return that data
	// because there's no binding to apply
	if !is_binding return binding;
	
	// check to make sure we have a valid data context
	if is_undefined(data_context) {
		// TODO log warning
		return noone;
	}	
	
	var data = data_context;
	
	// the path might be $data if we're just trying to apply a transform to the data_context
	if binding.path = "$data" {
		// data is already set to the data_context
	}
	else if binding.path != "" {
		// convert the binding path to field names and access them recursively
		var tokens = yui_string_split(binding.path, ".");

		var i = 0; repeat array_length(tokens) {		
			if is_string(data) {
				return noone; // invalid
			}
			
			var token = tokens[i++];
			data = data[$ token];
			if is_undefined(data) {
				return noone;
			}
		}
	}
	
	// TODO: resolve things like this when we load the yui file since the names are static!
	// NOTE: this now happens in YuiBinding but not everything is converted yet
	
	if variable_struct_exists(binding, "transform") {
		var transform = yui_resolve_transform(binding.transform, resources);
		if is_struct(transform) {
			data = transform.transform_function(data, transform.transform_props);
		}
		else {
			data = transform(data);
		}
	}
	
	// supports simple equality checking to avoid needing a custom transform for negation etc
	var equalsValue = binding[$ "equals"];
	if !is_undefined(equalsValue) {
		data = data == equalsValue;
	}
	
	return data;
}