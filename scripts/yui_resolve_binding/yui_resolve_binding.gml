/// @description resolves a value from a struct via a potentially-nested field path
/// @param binding - either a binding struct or the raw value
/// @param data_context - the data to resolve the binding against
/// @param view_item - the view item associated with the data
function yui_resolve_binding(binding, data_context, view_item = undefined) {
	
	if yui_is_binding(binding) {
		//if binding.trace {
		//	var trace = true;
		//}
		return binding.resolve(data_context, view_item);
	}
	
	if yui_is_binding_expr(binding) {
		throw "binding expression should be bound with yui_bind";
	}
	
	return binding;
}