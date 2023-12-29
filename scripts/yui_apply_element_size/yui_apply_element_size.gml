// TODO next major version - delete this

///// @description applies the element.size constraints to the drawn size
//function yui_apply_element_size(element_size, available_size, drawn_size) {
	
//	var element_w = element_size.is_w_bound ? element_size.w.resolve() : element_size.w;
//	var element_h = element_size.is_h_bound ? element_size.h.resolve() : element_size.h;
	
//	// width
//	if element_w == "stretch" {
//		drawn_size.w = max(available_size.w, element_size.min_w ?? 0);
//	}
//	else if is_numeric(element_size.min_w) {
//		drawn_size.w = clamp(drawn_size.w, element_size.min_w, max(available_size.w, element_size.min_w));
//	}
//	else if is_numeric(element_w) {
//		drawn_size.w = min(element_w, available_size.w);
//	}
	
//	// height
//	if element_h == "stretch" {
//		drawn_size.h = max(available_size.h, element_size.min_h ?? 0);
//	}	
//	else if is_numeric(element_size.min_h) {
//		drawn_size.h = clamp(drawn_size.h, element_size.min_h, max(available_size.h, element_size.min_h));
//	}
//	else if is_numeric(element_h) {
//		drawn_size.h = min(element_h, available_size.h);
//	}
	
//	return drawn_size;
//}