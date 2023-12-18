/// @description


if trace
	DEBUG_BREAK_YUI

// Inherit the parent event
event_inherited();

// support text animation
if !use_scribble && text_value.is_live {
	if text_value.update(data_source) {
		buildTextSurface(text_value.value);
		exit;
	}
}


if !use_scribble && !rebuild {
	if opacity_changed {
		buildTextSurface();
	}
}