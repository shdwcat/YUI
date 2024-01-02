// INSPECTRON - A Fluent API for easily creating GM debug overlays
// copyright @shdwcat 2023 

// === Configuration - edit these if you want! ===

// whether to automatically call InspectronSetGesture with the gesture settings below
#macro INSPECTRON_GESTURE_ENABLED true

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