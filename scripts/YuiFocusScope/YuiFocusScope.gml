/// @description here
function YuiFocusScope(root_item, parent) constructor {
	// the render item at the root of the focus scope
	self.root_item = root_item;
	
	// the parent focus scope
	self.parent = parent;
	
	// the currently focused item in this scope
	focused_item = undefined;
	
	// the autofocus target for this scope
	autofocus_target = undefined;
	
	// track this for easier debugging
	id = root_item._id;
	
	// used in yui_find_focus_item to check if the item is a valid match for this scope
	function matches(other_item) {
		// an item matches if it has the same scope (and isn't the scope root)
		// or if its the root of a scope whose parent is the same scope
		// (this allows navigating from the root of one scope to another sibling scope)
		return other_item.focus_scope == self && other_item != root_item
			|| other_item.is_focus_root && other_item.focus_scope.parent == self;
	}
	
	function focus(item) {
		focused_item = item;
		yui_log($"set focus for scope {id} to {item ? item._id : "undefined"}");
	}
}