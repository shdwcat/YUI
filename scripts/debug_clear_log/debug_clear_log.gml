/// @description reset debug log
function debug_clear_log() {
	debug.debug_output = "";
	debug.runner_count = 0;
}

function debug_count_instances(obj_index) {
	var count = 0;
	with (obj_index) {
		count++;
	}
	return count;
}