/// @description determines whether a struct is a type of YUI Binding
function yui_is_binding(binding) {
	return is_struct(binding) && is_instanceof(binding, YuiExpr);
}

function yui_is_live_binding(binding) {
	return is_struct(binding) && binding[$ "is_yui_live_binding"] == true;
}

function yui_is_call(binding) {
	return is_struct(binding) && binding[$ "is_call"] == true;
		//&& (instanceof(binding) == "YuiCallFunction" || instanceof(binding) == "YuiSetValue");
}

function yui_is_lambda(binding) {
	return is_struct(binding) && binding[$ "is_lambda"] == true;
		//instanceof(binding) == "YuiLambda";
}