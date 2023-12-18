/// @description execution environment
/// @param {struct.GsplEnvironment} enclosing_env
function GsplEnvironment(enclosing_env = undefined) constructor {
	self.values = {};
	self.enclosing = enclosing_env;
	
	static define = function(name /* string */, value) {
		variable_struct_set(values, name, value);
	}
	
	static assign = function(name /* GsplToken */, value) {
		if variable_struct_exists(values, name._lexeme) {
			variable_struct_set(values, name._lexeme, value);			
		}
		else if enclosing != undefined {
			enclosing.assign(name, value);
		}
		else {
			throw new GsplRuntimeError(name, "Undefined variable '" + name._lexeme + "'.");
		}
	}
	
	/// @func get
	/// @param {struct.GsplToken} name
	static get = function(name /* GsplToken */) {
		if variable_struct_exists(values, name._lexeme) {
			return variable_struct_get(values, name._lexeme);
		}
		else if enclosing != undefined {
			return enclosing.get(name);
		}
		else {
			return undefined; // until we support ?. !
			//throw new GsplRuntimeError(name, "Undefined variable '" + name._lexeme + "'.");
		}
	}
}