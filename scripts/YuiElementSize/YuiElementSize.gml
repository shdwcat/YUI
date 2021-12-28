/// @description initializes a new YuiElementSize from raw size props { w, h }
function YuiElementSize(size) constructor {
	// debug
	original_size = size;
	
	is_exact_size = false;
	w = undefined;
	h = undefined;
	min_w = 0;
	max_w = NaN;
	min_h = 0;
	max_h = NaN;
	
	if is_numeric(size) {
		var temp = {
			w: size,
			h: size,
		};
		size = temp;
	}
	
	if size == "auto" || size == undefined || size == noone {
		w = "auto";
		h = "auto";
	}
	else if size == "content" {
		w = "content";
		h = "content";
	}
	else if size == "stretch" {
		w = "stretch";
		h = "stretch";
	}
	else if is_struct(size) {
		if size[$ "w"] == undefined {
			w = "auto";
		}
		else {
			w = size.w;
		}
		
		if size[$ "h"] == undefined {
			h = "auto";
		}
		else {
			h = size.h;
		}
		
		min_w = size[$ "min_w"];
		max_w = size[$ "max_w"];
		min_h = size[$ "min_h"];
		max_h = size[$ "max_h"];
				
		is_exact_size = is_numeric(w) && is_numeric(h);		
		
	}
	else {
		yui_warning("Invalid size:", size);
	}
	
	max_w ??= infinity;
	max_h ??= infinity;
}