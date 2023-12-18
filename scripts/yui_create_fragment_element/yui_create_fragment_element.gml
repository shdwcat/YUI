/// @description creates a element from the provided fragment element props and definition
function yui_create_fragment_element(fragment_element_props, fragment_definition, resources, slot_values) {
	
	// deep copy the fragment content so that we don't share
	// the content struct with other instances of the same fragment
	var content = yui_deep_copy(fragment_definition.content);
	
	// store the original .yui type name for reflection purposes
	fragment_element_props.yui_type = fragment_element_props.type;
	
	// track the fragment type and definition to apply to props
	fragment_element_props.template_type = fragment_element_props.type;
	fragment_element_props.template_def = content;
	
	// set the type to the definition root type to prevent recursion
	fragment_element_props.type = content.type;
	
	var element_constructor = YuiGlobals.element_map[$ fragment_element_props.type];
	var element = new element_constructor(fragment_element_props, resources, slot_values);
	
	return element;
}