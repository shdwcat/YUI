// INSPECTRON - A Fluent API for easily creating GM debug overlays
// copyright @shdwcat 2023 

// === Configuration - edit these if you want! ===

// whether to automatically create a basic inspectron for instances that don't define one
#macro INSPECTRON_AUTO_INSPECT_ENABLED true

// whether to automatically call InspectronSetGesture with the gesture settings below
#macro INSPECTRON_GESTURE_ENABLED false

// mouse button and optional modifier key to trigger Inspectron if enabled above
#macro INSPECTRON_GESTURE_MOUSE_BUTTON mb_middle
#macro INSPECTRON_GESTURE_MODIFIER vk_shift			// set to undefined for no modifier

// default size of the debug overlay
#macro INSPECTRON_WIDTH 700
#macro INSPECTRON_HEIGHT 550

// minimum size of the overlay if space is restricted
#macro INSPECTRON_MIN_WIDTH 500
#macro INSPECTRON_MIN_HEIGHT 300

// how much to indent nested values (e.g. structs or linked instances)
#macro INSPECTRON_INDENT "    "

// defines how the mouse x,y coordinates are obtained
// (you most likely don't need to change this unless you are doing very advanced things with cameras)
#macro INSPECTRON_MOUSE_X mouse_x
#macro INSPECTRON_MOUSE_Y mouse_y