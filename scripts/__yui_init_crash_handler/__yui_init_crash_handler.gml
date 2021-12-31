// register the exception handler when we're not in debug mode
// (otherwise this will prevent us from breaking in the debugger at the error site)
if !debug_mode {
	exception_unhandled_handler(function(ex) {
	
	
		// Print some messages to the output log
	    show_debug_message( "--------------------------------------------------------------");
	    show_debug_message( "Unhandled exception " + string(ex) );
	    show_debug_message( "--------------------------------------------------------------");

	    // Write the exception struct to a file
		var crash_file = YUI_LOCAL_PROJECT_DATA_FOLDER + "crash.txt";
	    if file_exists(crash_file) file_delete(crash_file);
	    var _f = file_text_open_write(crash_file);
	    file_text_write_string(_f, string(ex));
	    file_text_close(_f);

	    // Show the error message (for debug purposes only)
	    show_message(ex.longMessage);

	    return 13; // made up number to differentiate from other error numbers
	});
}