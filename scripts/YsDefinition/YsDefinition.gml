/// @description here
function YsDefinition() : MxDefinition(undefined, ys_parser_definition()) constructor {
	struct_expressions.check_element_state = YuiCheckElementState;
}

function ys_parser_definition() {
	return new YsParserDefinition();
}