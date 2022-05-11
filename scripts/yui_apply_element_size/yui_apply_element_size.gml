/// @description applies the element.size constraints to the drawn size
function yui_apply_element_size(element_size, available_size, drawn_size) {
	
	// width
	if element_size.w == "stretch" {
		drawn_size.w = max(available_size.w, element_size.min_w ?? 0);
	}
	else if is_numeric(element_size.min_w) {
		drawn_size.w = clamp(drawn_size.w, element_size.min_w, max(available_size.w, element_size.min_w));
	}
	else if is_numeric(element_size.w) {
		drawn_size.w = min(element_size.w, available_size.w);
	}
	
	// height
	if element_size.h == "stretch" {
		drawn_size.h = max(available_size.h, element_size.min_h ?? 0);
	}	
	else if is_numeric(element_size.min_h) {
		drawn_size.h = clamp(drawn_size.h, element_size.min_h, max(available_size.h, element_size.min_h));
	}
	else if is_numeric(element_size.h) {
		drawn_size.h = min(element_size.h, available_size.h);
	}
	
	return drawn_size;
}