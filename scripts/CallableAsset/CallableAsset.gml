/// @description here
function CallableAsset(asset) : Callable() constructor {
	self.asset = asset;
		
	static arity = function() {
		return undefined;
	}

	static call = function(interpreter, args) {
		try {
			return script_execute_ext(asset, args);
		}
		catch (error) {
			debug_log("error calling asset: " + string(error));
			throw error;
		}
	}
}