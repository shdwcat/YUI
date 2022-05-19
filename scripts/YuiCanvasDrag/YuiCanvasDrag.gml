// TODO next major version - rename to YuiElementDrag
/// @description
function YuiElementDrag(_props, _resources) constructor {
	
	static default_props = {
		id: undefined,
		type: "element_drag",
		
		clamp_to_size: true,
		
		normalized: false, // whether to normalize the resulting position within the size of the canvas
		
		condition: undefined,
		on_position_changed: undefined,

		trace: false,
	};
	
	props = yui_init_props(_props);
	resources = _resources;
	
	static canStart = function(source_data) {
		return true; // eval condition?
	}
	
	static start = function(source_data, event, source_item) {
		
		// NOTE: assumes initiating event is a mouse button event
		button = event[$ "button"] ?? mb_left;
		
		// TODO: init_props on the parameters (and define defaults in .yui)
		parameters = variable_struct_get(event, "parameters") ?? {};
		
		on_position_changed = parameters[$ "on_position_changed"] ?? props.on_position_changed;
		
		target = source_item;
		parent = source_item.parent;
		position = {
			left: 0,
			top: 0,
		};
		
		return undefined;
	}
	
	static update = function(visual_item, cursor_pos) {
		
		var canvas_size = parent.draw_size;
		
		var canvas_left = cursor_pos.x - canvas_size.x;
		var canvas_top = cursor_pos.y - canvas_size.y;
		
		if props.clamp_to_size {
			canvas_left = clamp(canvas_left, 0, canvas_size.w);
			canvas_top = clamp(canvas_top, 0, canvas_size.h);
		}
		
		if props.normalized {
			canvas_left = canvas_left / canvas_size.w;
			canvas_top = canvas_top / canvas_size.h;
		}
		
		// position is either the raw position relative to the canvas x/y,
		// or the normalized position within the canvas size (relative to the x/y)
		position.left = canvas_left;
		position.top = canvas_top;
		
		if props.trace {
			yui_log("left", canvas_left, "-", "top", canvas_top);
		}

		yui_call_handler(on_position_changed, [position], target.data_context);
		
		if mouse_check_button_released(button) {
			finish();
		}
	}
	
	static resetFrame = function() {
		// nothing to reset here
	}
	
	static finish = function() {
		YuiCursorManager.finishInteraction();
		
		parameters = undefined;
		button = undefined;
		target = undefined;
		parent = undefined;
		position = undefined;
		on_position_changed = undefined;
	}
}