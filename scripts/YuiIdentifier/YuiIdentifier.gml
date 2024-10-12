/// @description stores the name of an identifier
function YuiIdentifier(identifier) : YuiExpr() constructor {
	static is_yui_live_binding = false;

	self.identifier = identifier;
	
	static resolve = function(data) {
		// currently identifier just resolves to the string, which means any unquoted string
		// in script will resolve to a string if it's not used where a function is expected
		// and if it doesn't match a lambda variable name
		
		return identifier;
	}

	static compile = function()
	{
		return "\"" + identifier + "\"";
	}
}

