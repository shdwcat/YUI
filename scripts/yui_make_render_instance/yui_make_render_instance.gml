/// @description create and initialize a render instance
function yui_make_render_instance(yui_element, data, index = 0, depth_offset = 0) {
	
	var render_object = yui_resolve_render_item(yui_element.props.type, yui_element.props);
	if render_object == undefined {
		throw yui_error("unknown element type:", yui_element.props.type);
	}
	
	depth_offset += yui_element.props.layer;
	
	// NOTE: expects to be called from an yui_base-derived object

	var child = instance_create_depth(x, y, depth - (1 + depth_offset), render_object);
	child.data_context = data
	child.parent = self;
	child.item_index = index;
	child.yui_element = yui_element;
	child.persistent = persistent;

	// TODO: move to child.init() ?
	child.initLayout();
	child.bind_values();
	if child.visible {
		child.build();
	}
	
	return child;
}