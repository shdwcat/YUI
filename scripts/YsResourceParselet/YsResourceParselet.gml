/// @description
function YsResourceParselet() : GsplPrefixParselet() constructor {
	
	static parse = function(parser, token) {
		var path = token._lexeme;
		
		// given 'foo.bar.baz' get 'foo' and 'bar.baz'
		var path_parts = yui_string_split(path, ".", 2);

		if !variable_struct_exists(parser.resources, path_parts[0]) {
			// TODO: only throw in debug mode (?)
			throw yui_warning("Could not find resource with name: " + path_parts[0]);
		}

		var resource = parser.resources[$ path_parts[0]];
		
		var sub_path = array_length(path_parts) > 1
			? path_parts[1]
			: "";
		
		// TODO default this to not live since resources *should* be static?
		return new YuiValueBinding(resource, sub_path);
	}	
}