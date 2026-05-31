/// @description YUI Element that draws a line from one point to another
function YuiLineElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "line",
		padding: 0,
		
		draw_to_world: false, // whether to draw world coordinates
		line_start: undefined, // x1,y1
		line_end: undefined, // x2,y2
		width: 1,
		color: c_white,
		color_end: undefined,
		
		// requires CleanShapes
		clean: false, // will automatically be true if the below is used
		
		alpha: undefined, // alpha for the line (defaults to 1)
		alpha_end: undefined, // alpha for the end of the line if different
		
		cap: undefined, // cap type for the start of the line (or both if cap_end not set)
		cap_end: undefined, // cap type for the end of the line
	};
	
	static cleanshapes_enabled = yui_check_cleanshapes();
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	use_cleanshapes = props.clean
		|| props.alpha != undefined
		|| props.alpha_end != undefined
		|| props.cap != undefined
		|| props.cap_end != undefined;
	if use_cleanshapes && !cleanshapes_enabled {
		throw yui_error($"Add CleanShapes to your project in order to use CleanLine features (in {props.id})");
	}
	
	line_start = yui_bind_struct(props.line_start, resources, slot_values);
	line_end = yui_bind_struct(props.line_end, resources, slot_values);
	
	width = yui_bind(props.width, resources, slot_values);
	color = yui_bind(props.color, resources, slot_values);	
	color_end = yui_bind(props.color_end, resources, slot_values);
	
	if use_cleanshapes {
		alpha = yui_bind(props.alpha, resources, slot_values);
		alpha_end = yui_bind(props.alpha_end, resources, slot_values);
		cap = yui_bind(props.cap, resources, slot_values);
		cap_end = yui_bind(props.cap_end, resources, slot_values);
	}
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			draw_to_world: props.draw_to_world,
			use_cleanshapes,
		};
	}
	
	// feather ignore GM2017
	static getBoundValues = function YuiLineElement_getBoundValues(data, prev) {
		var line_end = yui_resolve_binding(self.line_end, data);
		if !line_end return false;
		
		var line_start = yui_resolve_binding(self.line_start, data);
		
		var width = yui_resolve_binding(self.width, data);
		var color = yui_resolve_color(yui_resolve_binding(self.color, data));
		var color_end = yui_resolve_color(yui_resolve_binding(self.color_end, data));
		
		var x1 = yui_resolve_binding(line_start.x, data);
		var y1 = yui_resolve_binding(line_start.y, data);
		var x2 = yui_resolve_binding(line_end.x, data);
		var y2 = yui_resolve_binding(line_end.y, data);
		
		var next = {
			is_live: true,
			data_source: data,
			width: width,
			color: color,
			color_end: color_end ?? color, // default to single color line
			x1: x1,
			y1: y1,
			x2: x2,
			y2: y2,
		};
		
		if use_cleanshapes {
			var alpha = yui_resolve_binding(self.alpha, data) ?? 1;
			var alpha_end = yui_resolve_binding(self.alpha_end, data);
			var cap = yui_resolve_binding(self.cap, data);
			var cap_end = yui_resolve_binding(self.cap_end, data);
			
			next.alpha = alpha;
			next.alpha_end = alpha_end ?? alpha; // default to same alpha as start
			next.cap = cap;
			next.cap_end = cap_end ?? cap; // default to same cap as start
		}
			
		return next;
	}
}