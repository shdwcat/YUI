enum SELECTION_BEHAVIOR {
	Single,
	Multiple,
}

#macro SelectionScope YuiSelectionScope

/// @description class identifying a selection scope and associated behavior
function YuiSelectionScope(_id, _options) constructor {
	static default_props = {		
		selection_behavior: SELECTION_BEHAVIOR.Single,
		default_selected_item: noone,
	}
	
	var options = init_props_old(_options);
	
	id = _id;
	selection_behavior = options.selection_behavior;
	
	selected_item = options.default_selected_item;
	
	// NOTE: this should be called in the performActions() phase of the component!
	static select = function(selection) {
		switch selection_behavior {
			case SELECTION_BEHAVIOR.Single:
				selected_item = selection;
				break;
		}
	}
}