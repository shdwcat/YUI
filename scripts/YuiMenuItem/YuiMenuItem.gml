/// @description
function YuiMenuItem(label, icon_sprite = undefined, command = undefined) constructor {
	static type = "item";
	
	// the text label to display in the menu
	self.label = label;
	
	// sprite to use as an icon
	self.icon_sprite = icon_sprite;
	
	// action to perform on click (exclusive with children)
	self.command = command ?? function() {
		yui_log("clicked menu item");
	};
	
	self.visible = true;
}

function YuiMenuItemCheckable(label, icon_sprite = undefined, on_checked_changed = undefined, is_checked = false)
	: YuiMenuItem(label, icon_sprite) constructor {
	static type = "check_item";

	self.is_checked = is_checked;
	self.on_checked_changed = on_checked_changed;
	
	self.command = function() {
		is_checked = !is_checked;
		on_checked_changed(is_checked, self);
	}
}

/// @description
function YuiTopMenu(label, icon_sprite = undefined, children = undefined) : YuiMenuItem(label, icon_sprite) constructor {
	static type = "topmenu";
	
	// children to display in child popup (exclusive with command)
	self.children = children;
}

/// @description
function YuiSubMenu(label, icon_sprite = undefined, children = undefined) : YuiMenuItem(label, icon_sprite) constructor {
	static type = "submenu";
	
	// children to display in child popup (exclusive with command)
	self.children = children;
}