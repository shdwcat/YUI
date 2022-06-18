/// @description exits the game!
function yui_example_exit_game() {
	
	yui_write_compiled_functions_to_project();
	
	yui_log("Exiting game...");
	
	game_end();
	
}