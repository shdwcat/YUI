/// @description here
function yui_resolve_nested_binding(binding, data) {
	
	// TODO: implement this into YuiScript somehow
	
	if binding == noone return true;
	return binding.resolve(data);
}