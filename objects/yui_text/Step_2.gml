/// @description


if trace
	DEBUG_BREAK_YUI

// Inherit the parent event
event_inherited();


if !use_scribble && opacity_changed && !rebuild {
	buildTextSurface();
}