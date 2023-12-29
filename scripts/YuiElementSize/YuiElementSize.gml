enum YUI_LENGTH_TYPE {
	Pixel,
	Proportional,
}

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
	default_w = 0;
	default_h = 0;
	fill = false;
	
	w_type = YUI_LENGTH_TYPE.Pixel;
	h_type = YUI_LENGTH_TYPE.Pixel;
	
	if is_numeric(size) {
		var temp = {
			w: size,
			h: size,
		};
		size = temp;
	}
	
	if size == "auto" || size == undefined {
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
	else if size == "fill" {
		w = "auto";
		h = "auto";
		fill = true;
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
		min_h = size[$ "min_h"];
		max_w = size[$ "max_w"];
		max_h = size[$ "max_h"];
		fill = size[$ "fill"];
		
		is_exact_w = is_numeric(w);
		is_exact_h = is_numeric(h);
		is_exact_size = is_exact_w && is_exact_h;
		
		if is_exact_w
			default_w = w;
		if is_exact_h
			default_h = h;
		
		if variable_struct_exists(size, "w_type") {
			if size.w_type == "proportional" {
				w_type = YUI_LENGTH_TYPE.Proportional;
			}
		}
		if variable_struct_exists(size, "h_type") {
			if size.h_type == "proportional" {
				h_type = YUI_LENGTH_TYPE.Proportional;
			}
		}
	}
	else {
		yui_warning("Invalid size:", size);
	}
	
	max_w ??= infinity;
	max_h ??= infinity;
	
	is_w_bound = yui_is_binding(w);
	is_h_bound = yui_is_binding(h);
	
	/**
	 * Constrains the provided draw_size according to the element size config and available space
	 * @param {struct.YuiArrangeSize} arrange_size
	 * @param {struct} draw_size
	 */
	static constrainDrawSize = function(arrange_size, draw_size) {
		
		// NOTE: the draw_size parameter is modified and returned below
		
		var is_arrange_size = instanceof(arrange_size) == YuiArrangeSize;
		
		var available_max_w = is_arrange_size
			? arrange_size.max_w
			: arrange_size.w;
		
		var available_max_h = is_arrange_size
			? arrange_size.max_h
			: arrange_size.h;
		
		var element_w = is_w_bound ? w.resolve() : w;
		var element_h = is_h_bound ? h.resolve() : h;
	
		// width
		if element_w == "stretch" {
			draw_size.w = max(available_max_w, min_w ?? 0);
		}
		else if is_numeric(min_w) {
			draw_size.w = clamp(draw_size.w, min_w, max(available_max_w, min_w));
		}
		else if is_numeric(element_w) {
			draw_size.w = min(element_w, available_max_w);
		}
	
		// height
		if element_h == "stretch" {
			draw_size.h = max(available_max_h, min_h ?? 0);
		}	
		else if is_numeric(min_h) {
			draw_size.h = clamp(draw_size.h, min_h, max(available_max_h, min_h));
		}
		else if is_numeric(element_h) {
			draw_size.h = min(element_h, available_max_h);
		}
	
		return draw_size;
	}
}

function YuiFlexValue(value) constructor {
	is_normal = true;
	proportional = undefined;
	
	if value == true {
		proportional = 1;
		is_normal = false;
	}
	else if is_real(value) {
		proportional = value;
		is_normal = false;
		
		if proportional <= 0 {
			throw yui_error("Exact flex size must be greater than zero:", value);
		}
	}
	else if value != undefined {
		throw yui_error("Invalid flex value:", value);
	}
}



