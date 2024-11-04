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
	
	focus = function(item) {
		focused_item = item;
		focused_item.focused = true;
		
		if focused_item.on_got_focus focused_item.on_got_focus();
		
		yui_log($"set focus for scope {id} to {item ? item._id : "undefined"}");
	}
	
	// attempt to focus our current autofocus target
	doAutofocus = function() {
		if autofocus_target && instance_exists(autofocus_target) {
			autofocus_target.focus();
			return autofocus_target.focused;
		}
		else {
			yui_warning($"failed to autofocus in scope {id}");
		}
	}
	
	unfocus = function(item) {
		
		if item != autofocus_target && doAutofocus() {
			yui_log($"reset focus to autofocus target in scope {id}: {autofocus_target._id}");
		}
		else if parent {
			yui_log($"looking for focus in parent scope {parent.id}");
			parent.unfocus(item);
		}
		else {
			yui_log($"clearing focus due to no parent scope for {id}")
			YuiCursorManager.clearFocus();
		}
	}
}