/// @description applies the element.size constraints to the drawn size
function yui_apply_element_size(element_size, available_size, drawn_size) {
		
	if element_size.w == "stretch" {
		drawn_size.w = available_size.w;
	}
	else if is_numeric(element_size.w) {
		drawn_size.w = clamp(drawn_size.w, element_size.w, available_size.w);
	}
	
	if element_size.h == "stretch" {
		drawn_size.h = available_size.h;
	}	
	else if is_numeric(element_size.h) {
		drawn_size.h = clamp(drawn_size.h, element_size.h, available_size.h);
	}
	
	return drawn_size;
}