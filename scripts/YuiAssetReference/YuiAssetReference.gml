/// @description here
function YuiAssetReference(asset, source, is_runtime_function = false) : YuiExpr() constructor {
	static is_yui_live_binding = false;
	
	self.asset = asset;
	self.source = source;
	self.is_runtime_function = is_runtime_function;
	
	static trim_str = ["\"", "@"];
	
	static debug = function() {
		return $"{string_trim(json_stringify(asset), trim_str)} ({instanceof(self)})";
	}
		
	resolve = function() {
		return asset;
	}
}