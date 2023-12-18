/// @description GsplEnvironment that provides access to GML assets (functions, scripts, etc)
function GsplGmlEnvironment() : GsplEnvironment() constructor {
	
	static initRuntimeFunctions = function() {
		result = {};
		var i = 0;
		var function_name = script_get_name(i);
		do {
			if string_char_at(function_name, 1) != "@" {
				result[$ function_name] = new GsplCallableRuntimeFunction(i);
			}
			i++;
			function_name = script_get_name(i);
		}
		until function_name == "<unknown>";
		
		gspl_log($"Registered {i} runtime functions");
		
		return result;
	}
	
	static runtime_functions  = initRuntimeFunctions();
	
	static define = function(name /* string */, value) {
		// shouldn't be possible but just in case
		throw "Not Supported: cannot define values in GsplGmlEnvironment";
	}
	
	static assign = function(name /* GsplToken */, value) {
		throw "Not Supported: cannot assign values in GsplGmlEnvironment";
	}
	
	static get = function(name_token /* GsplToken */) {
		var name = name_token._lexeme;
		var asset = asset_get_index(name);
		if asset == -1 {
			return variable_struct_get(runtime_functions, name); // until we support ?. operator!
		}
		
		if asset_get_type(name) == asset_script {
			// wrap the asset in a GsplCallable for use in function calls
			return new GsplCallableAsset(asset);
		}
		else {
			// constants, objects, sprites etc!
			return asset;
		}
	}
}