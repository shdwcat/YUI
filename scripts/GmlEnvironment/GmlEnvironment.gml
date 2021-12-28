/// @description Environment that provides access to GML assets (functions, scripts, etc)
function GmlEnvironment() : Environment() constructor {
	
	static initRuntimeFunctions = function() {
		result = {};
		var i = 0;
		var function_name = script_get_name(i);
		do {
			result[$ function_name] = new CallableRuntimeFunction(i);
			i++;
			function_name = script_get_name(i);
		}
		until function_name == "<unknown>";
		
		log("Registered", i, "runtime functions");
		
		return result;
	}
	
	static runtime_functions  = initRuntimeFunctions();
	
	static define = function(name /* string */, value) {
		// shouldn't be possible but just in case
		throw "Not Supported: cannot define values in GmlEnvironment";
	}
	
	static assign = function(name /* Token */, value) {
		throw "Not Supported: cannot assign values in GmlEnvironment";
	}
	
	static get = function(nameToken /* Token */) {
		var name = nameToken._lexeme;
		var asset = asset_get_index(name);
		if asset == -1 {
			return variable_struct_get(runtime_functions, name); // until we support ?. operator!
		}
		
		if asset_get_type(name) == asset_script {
			// wrap the asset in a Callable for use in function calls
			return new CallableAsset(asset);
		}
		else {
			// constants, objects, sprites etc!
			return asset;
		}
	}
}