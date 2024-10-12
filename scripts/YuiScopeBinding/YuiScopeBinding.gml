/// @description binds the provided binding to a specific scope
function YuiScopeBinding(binding) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	
	self.binding = binding;
	self.scope = undefined;
	self.is_lambda = yui_is_live_binding(binding) && binding.is_lambda;
	
	static updateScope = function(scope) {
		self.scope = scope;
	}
	
	static resolve = function(data) {
		return yui_is_live_binding(binding) ? binding.resolve(scope) : binding;
	}
	
	static call = function(data, args) {
		return binding.call(scope, args);
	}
}