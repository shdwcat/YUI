/// @description binds the provided binding to a specific scope
function YuiScopeBinding(binding) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.binding = binding;
	self.scope = undefined;
	
	static updateScope = function(scope) {
		self.scope = scope;
	}
	
	static resolve = function(data) {
		return yui_is_live_binding(binding) ? binding.resolve(scope) : binding;
	}
}