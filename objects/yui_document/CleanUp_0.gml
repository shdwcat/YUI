/// @description clean up root item

if root && instance_exists(root) {
	root.unload();
}