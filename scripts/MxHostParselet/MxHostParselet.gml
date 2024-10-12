/// @description here
function MxHostParselet() : GsplPrefixParselet() constructor {
	
	static runtime_functions = gspl_get_runtime_function_map();
	
	static parse = function(parser, token) {
		var name = token._lexeme;
		if name == "" {
			throw yui_error("host (~) must be followed by an identifier");
		}
		
		// TODO: should this part go in the YuiExpr to decouple from this parselet?
		
		var runtime_function = runtime_functions[$ name];
		if runtime_function != undefined {
			var asset = asset_get_index(name);		
			yui_log_asset_use(name, "GML Runtime Function", parser.source);
			
			return new YuiAssetReference(runtime_function, parser.source, true); 
			
			// YuiCallFunction is very hacky and expects just the name of the runtime function
			// not the function index itself
			return new YuiIdentifier(name);
		}
		
		var asset = asset_get_index(name);		
		if asset == -1 {
			// TODO: only throw in debug mode (?)
			throw yui_warning($"Could not find GM host asset with name: {name}");
		}
		
		var asset_type = asset_get_type(name);
		var asset_type_name = string_split(string(asset), " ", 3)[1];
		
		yui_log_asset_use(name, asset_type_name, parser.source);
		
		//if asset_type == asset_script {
		//	// YuiCallFunction is very hacky and expects just the name of the script
		//	// not the script index itself
		//	return new YuiIdentifier(name);
		//}		
		
		return new YuiAssetReference(asset, parser.source);
	}
}