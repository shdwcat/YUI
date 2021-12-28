/// @description
function YuiValueWrapper(value, type = undefined) constructor {
	static is_yui_binding = true;
	
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
}