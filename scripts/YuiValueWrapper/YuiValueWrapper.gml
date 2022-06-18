/// @description
function YuiValueWrapper(value, type = undefined) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = false;
	
	// TODO: move this to .getLiteral() on the token class
	if type == YS_TOKEN.TRUE
		value = true;
	else if type == YS_TOKEN.FALSE
		value = false;
	else if type == YS_TOKEN.UNDEFINED
		value = undefined;
	
	self.value = value
	
	resolve = function() {
		return value;
	}
	
	static checkType = function() {
		return typeof(value);
	}

	static compile = function()
	{
		switch typeof(value) {
			case "string":
				return "\"" + value + "\"";
			case "number":
				return string(value);
			case "bool":
				return value == true ? "true" : "false";
			case "undefined":
				return "undefined";
				
			//case "struct":
			//	return value; // hmmm
				
			default:
				throw yui_error("cannot compile value of type: " + typeof(value));
		}
	}
}