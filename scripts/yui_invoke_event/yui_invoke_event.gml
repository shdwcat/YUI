/// @description invokes an event on a view item
function yui_invoke_event(view_item, event_name, event_args) {
	
	if view_item == undefined
		throw yui_error("attempted to invoke event on undefined view_item");
	if event_name == undefined
		throw yui_error("attempted to invoke event without a name");
	
	var matched_event = undefined;
	var item = view_item;
		
	while matched_event == undefined {
		// check if we ran out of parents
		if item == undefined || !variable_struct_exists(item, "events") {
			throw yui_error("unable to find view item with event:", event_name);
		};
			
		// check if we found it
		var is_event_defined = variable_struct_exists(item.events, event_name);
		if is_event_defined {
			var matched_event = item.events[$ event_name];
			if matched_event != undefined break;
			else {
				// if the event is defined but not handled, act as if it was captured
				// (we don't want e.g. an item_selected event bubbling up to an enclosing item selector)
				return;
			}
		}
			
		// recurse up
		item = item.parent;
	}
	
	// NOTE: invokes the event against the item and datacontext the event was found on
	// NOTE: ignores 'data_source' prop of that item!
	yui_log($"invoking event '{event_name}'");
	yui_call_handler(matched_event, [event_args], item.data_source);
}