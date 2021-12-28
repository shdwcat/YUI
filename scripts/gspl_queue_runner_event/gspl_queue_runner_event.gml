/// @description queues an event on the gspl_runner for the current fiber
function gspl_queue_runner_event(runner_event, is_gui = false) {
	
	// TODO: queue instead of set
	switch (is_gui) {
		case false:
			runner.draw_fiber = runner_event.fiber;
			break;
		case true:
			runner.drawgui_fiber = runner_event.fiber;
			break;
	}
}