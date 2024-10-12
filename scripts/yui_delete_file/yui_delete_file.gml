/// @description try to delete the file if it exists, but fail if we couldn't delete it
function yui_try_delete_file(filename) {
	if file_exists(filename) && !file_delete(filename) {
		throw yui_error($"failed to delete {filename}")
	}
}