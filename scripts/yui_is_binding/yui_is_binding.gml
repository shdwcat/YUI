/// @description determines whether a struct is a type of YUI Binding
function yui_is_binding(binding) {
	return is_struct(binding) && binding[$ "is_yui_binding"] == true;
}