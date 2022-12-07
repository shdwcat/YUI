/// @description


if trace
	DEBUG_BREAK_YUI

// Inherit the parent event
event_inherited();


if !use_scribble && !rebuild {
	if opacity_changed {
		buildTextSurface();
	}
}