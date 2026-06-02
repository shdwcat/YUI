/// @description create and initialize a render instance
function yui_make_render_instance(yui_element, data, index = 0, depth_offset = 0) {
	
	var render_object = yui_resolve_render_item(yui_element.props.type, yui_element.props);
	if render_object == undefined {
		throw yui_error("unknown element type:", yui_element.props.type);
	}
	
	depth_offset += yui_element.props.layer;
	
	// NOTE: expects to be called from a yui_base-derived object or yui_document
	var parent = self;
	var focus_scope = undefined;
	
	if instanceof(parent) == "instance" {
		if object_index == yui_document {
			document = parent;
			
			// document doesn't have all the expected parent properties
			parent = undefined;
		}
		else if object_is_ancestor(parent.object_index, yui_base) {
			document = parent.document;
			focus_scope = parent.focus_scope;
		}
		else if object_is_ancestor(parent.object_index, yui_game_item) {
			// game items don't have all the parent properties
			parent = undefined;
		}
		else {
			throw yui_error($"yui_make_render_instance: unexpected parent type: {instanceof(parent)}");
		}
	}
	else {
		throw yui_error($"yui_make_render_instance: unexpected parent type: {typeof(parent)}");
	}
		
	var child = instance_create_depth(x, y, depth - (1 + depth_offset), render_object, {
		data_context: data,
		yui_element,
		persistent,
		parent,
		document,
		focus_scope,
		item_index: index,
	});
	
	with child {
		initLayout();
		bind_values();
		if visible {
			build();
			process(/* became_visible */ true);
		}
	}
	
	return child;
}