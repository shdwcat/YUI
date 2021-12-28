/// @description initializes a new YuiElementAlignment from the raw alignment value
function YuiElementAlignment(alignment, h_default = "left", v_default = "top") constructor {
	if alignment == undefined {
		h = h_default;
		v = v_default;
	}
	else if alignment == "default" {
		h = h_default;
		v = v_default;
	}
	else if is_string(alignment) {
		h = alignment;
		v = alignment;
	}
	else if is_struct(alignment) {
		h = alignment[$"h"];
		v = alignment[$"v"];
		
		if h == undefined h = h_default;
		if v == undefined v = v_default;
	}
	else {
		throw "unsupported alignment value";
	}	
}