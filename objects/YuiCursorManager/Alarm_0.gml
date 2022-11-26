/// @description fire delayed click and/or reset double_click timer

if queued_event != undefined && instance_exists(queued_target) {
	//yui_log("calling queued event", queued_event);
	var call = method(queued_target, queued_method);
	call();
	clearQueuedEvent();
	click_count = 0;
}


