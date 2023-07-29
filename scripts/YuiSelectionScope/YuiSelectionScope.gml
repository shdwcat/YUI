enum SELECTION_BEHAVIOR {
	Single,
	Multiple,
}

#macro SelectionScope YuiSelectionScope

// TODO: multi select can go in YuiMultiSelectionScope

/// @description class identifying a selection scope and associated behavior
function YuiSelectionScope(_id, _options = {}) constructor {
	static default_props = {		
		selection_behavior: SELECTION_BEHAVIOR.Single,
		default_selected_item: undefined,
	}
	
	var options = yui_apply_props(_options);
	
	id = _id;
	selection_behavior = options.selection_behavior;
	
	selected_item = options.default_selected_item;
		
	select = function(selection) {
		switch selection_behavior {
			case SELECTION_BEHAVIOR.Single:
				selected_item = selection;
				break;
		}
	}
}

function YuiArraySelector(items, selected_item = undefined, on_selected = undefined) constructor {
	self.items = items;
	self.on_selected = on_selected;
		
	select = function(item) {
		if item != undefined {
			var index = yui_array_find_index(items, item);
			if index >= 0 {
				self.selected_index = index;
				self.selected_item = item;
			}
			else {
				throw yui_error("unable to find provided item in items array");
			}
		}
		else {
			self.selected_index = -1;
			self.selected_item = undefined;
		}
		
		if (on_selected != undefined) {
			on_selected(item);
		}
	}
	
	if selected_item == undefined {
		if array_length(items) > 0 {
			self.selected_index = 0;
			self.selected_item = items[0];
		}
		else {
			self.selected_index = -1;
			self.selected_item = undefined;
		}
	}
	else {
		select(selected_item);
	}
	
	self.selected_item = selected_item
		?? (array_length(items) > 0 ? items[0] : undefined);
	
	selectPreviousIndex = function() {
		if selected_index <= 0 {
			throw yui_error("Cannot select index below 0");
		}
		else {
			selected_index--;
			selected_item = items[selected_index];
		}
	}
	
	canSelectNextIndex = function() {
		return selected_index + 1 < array_length(items);
	}
	
	selectNextIndex = function() {
		if !canSelectNextIndex() {
			throw yui_error("Cannot select index above item count");
		}
		else {
			selected_index++;
			selected_item = items[selected_index];
		}
	}
}