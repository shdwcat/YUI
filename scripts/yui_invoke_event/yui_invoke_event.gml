/// @description invokes an event on a view item
function yui_invoke_event(params, event, view_item) {
	
	var event_name = params.event;

	var matched_event = undefined;
	var item = view_item;
		
	while matched_event == undefined {
		// check if we ran out of parents
		if item == undefined {
			throw yui_error("unable to find view item with event:", event_name);
		};
			
		// check if we found it
		var matched_event = item.events[$ event_name];
		if matched_event != undefined break;
			
		// recurse up
		item = item.parent;
	}
	
	var event_info = { data: params.data };
	
	// NOTE: invokes the event against the item and datacontext the event was found on
	// NOTE: ignores 'data_source' prop of that item!
	yui_handle_event(matched_event, item.data_context, item, event_info);
}