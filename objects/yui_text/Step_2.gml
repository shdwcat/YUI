/// @description bind / layout

// Inherit the parent event
event_inherited();

// support text animation
if use_text_surface {
	if text_value.is_live && text_value.update(data_source) {
		buildTextSurface(text_value.value);
		exit;
	}

	if opacity_changed {
		buildTextSurface();
		exit;
	}
}