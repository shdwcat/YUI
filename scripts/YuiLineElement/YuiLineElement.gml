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
	};
	
	props = yui_init_props(_props);
	
	baseInit(props);
	
	props.line_start = yui_bind_struct(props.line_start, resources, slot_values);
	props.line_end = yui_bind_struct(props.line_end, resources, slot_values);
	
	props.width = yui_bind(props.width, resources, slot_values);
	props.color = yui_bind(props.color, resources, slot_values);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			draw_to_world: props.draw_to_world,
		};
	}
	
	static getBoundValues = function YuiLineElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var line_end = yui_resolve_binding(props.line_end, data);
		if !line_end return false;
		
		var line_start = yui_resolve_binding(props.line_start, data);
		
		var width = yui_resolve_binding(props.width, data);
		var color = yui_resolve_color(yui_resolve_binding(props.color, data));
		
		var x1 = yui_resolve_binding(line_start.x, data);
		var y1 = yui_resolve_binding(line_start.y, data);
		var x2 = yui_resolve_binding(line_end.x, data);
		var y2 = yui_resolve_binding(line_end.y, data);
			
		return {
			is_live: true,
			width: width,
			color: color,
			x1: x1,
			y1: y1,
			x2: x2,
			y2: y2,
		};
	}
}