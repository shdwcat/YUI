// define all YUI globals
global.__yui_globals = {};

// converts placement string values from a yui_file to the enum equivalent
global.__yui_globals.placement_map = {
	top_left: placement_mode.TopLeft,
	top_center: placement_mode.TopCenter,
	top_right: placement_mode.TopRight,
	left_top: placement_mode.LeftTop,
	left_middle: placement_mode.LeftCenter,
	left_bottom: placement_mode.LeftBottom,
	bottom_left: placement_mode.BottomLeft,
	bottom_center: placement_mode.BottomCenter,
	bottom_right: placement_mode.BottomRight,
	right_top: placement_mode.RightTop,
	right_middle: placement_mode.RightCenter,
	right_bottom: placement_mode.RightBottom,	
};

exception_unhandled_handler(function(ex)
{
    // Print some messages to the output log
    show_debug_message( "--------------------------------------------------------------");
    show_debug_message( "Unhandled exception " + string(ex) );
    show_debug_message( "--------------------------------------------------------------");

    // Write the exception struct to a file
    if file_exists("crash.txt") file_delete("crash.txt");
    var _f = file_text_open_write("crash.txt");
    file_text_write_string(_f, string(ex));
    file_text_close(_f);


    // Show the error message (for debug purposes only)
    show_message(ex.longMessage);

    return 0;
}); 