/// @description here
function MxHostParselet() : GsplPrefixParselet() constructor {
	
	static runtime_functions = gspl_get_runtime_function_map();
	
	static parse = function(parser, token) {
		var path = token._lexeme;
		
		// given 'foo.bar.baz' get 'foo' and 'bar.baz'
		var path_parts = yui_string_split(path, ".", 2);
		var name = path_parts[0];
		var sub_path = array_length(path_parts) > 1
			? path_parts[1]
			: "";
			
		if name == "" {
			throw yui_error("host (~) must be followed by an identifier");
		}
		
		// TODO: should this part go in the YuiExpr to decouple from this parselet?
		
		var runtime_function = runtime_functions[$ name];
		if runtime_function != undefined {
			if sub_path != "" {
				throw yui_error($"Cannot use subpath expression with runtime functions ({path})");
			}
			
			yui_log_asset_use(name, "GML runtime function", parser.source);
			
			// YuiCallFunction is very hacky and expects just the name of the runtime function
			// not the function index itself
			return new YuiIdentifier(name);
		}
		
		var asset = asset_get_index(name);		
		if asset == -1 {
			// TODO: only throw in debug mode (?)
			throw yui_warning($"Could not find GM host asset with name: {path_parts[0]}");
		}
		
		var asset_type = asset_get_type(name);
		var asset_type_name = string_split(string(asset), " ", 3)[1];
		
		// objects are the only asset where we can apply subpathing
		// TODO could it work for e.g. sequences?
		if asset_type == asset_object {
			yui_log_asset_use(name, asset_type_name, parser.source);
			return new YuiValueBinding(asset, sub_path);
		}
		else if sub_path != "" {
			throw yui_error($"Cannot use subpath expression with asset type {asset_type}");
		}
		
		// log anything else
		yui_log_asset_use(name, asset_type_name, parser.source);
		
		if asset_type == asset_script {
			// YuiCallFunction is very hacky and expects just the name of the script
			// not the script index itself
			return new YuiIdentifier(name);
		}		
		
		return new YuiValueWrapper(asset, "");
	}
}