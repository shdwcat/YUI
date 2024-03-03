// ==============================
// |     YUI Configuration      |
// |                            |
// |   Please edit this file!   |
// ==============================

#macro DEFAULT_THEME_NAME "default"

// macro to control whether YUI should attempt to use Input 6 library for navigation and interaction
#macro YUI_INPUT_LIB_ENABLED false

// whether to use Quick Setup mode
// Automatically configures some verbs to work properly with the default profiles in __input_config_verbs
#macro YUI_INPUT_LIB_QUICK_SETUP true

// Map input verbs to YUI navigation actions
// The default values here match the default values in __input_config_verbs
#macro YUI_INPUT_VERB_LEFT "left"
#macro YUI_INPUT_VERB_RIGHT "right"
#macro YUI_INPUT_VERB_UP "up"
#macro YUI_INPUT_VERB_DOWN "down"

// these are used for cursor-scoped scrolling (the thing being hovered)
// mouse/virtual cursor
#macro YUI_INPUT_VERB_SCROLL_UP "scroll_up"
#macro YUI_INPUT_VERB_SCROLL_DOWN "scroll_down"
#macro YUI_INPUT_VERB_SCROLL_LEFT "scroll_left"
#macro YUI_INPUT_VERB_SCROLL_RIGHT "scroll_right"

// these are used for focus-scoped scrolling (the thing that is focused)
// keyboard/gamepad
#macro YUI_INPUT_VERB_PAD_SCROLL_UP "aim_up"
#macro YUI_INPUT_VERB_PAD_SCROLL_DOWN "aim_down"
#macro YUI_INPUT_VERB_PAD_SCROLL_LEFT "aim_left"
#macro YUI_INPUT_VERB_PAD_SCROLL_RIGHT "aim_right"

#macro YUI_INPUT_VERB_ACCEPT ["accept", "action"]
#macro YUI_INPUT_VERB_CANCEL "cancel"