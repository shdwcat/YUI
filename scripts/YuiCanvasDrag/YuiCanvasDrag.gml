/// @description
function YuiCanvasDrag(_props, _resources) constructor {
	
	static default_props = {
		id: undefined,
		type: "canvas_drag",
		
		camera_index: 0,
		drag_scale: 1,
		
		clamp_to_size: true,
		
		normalized: false, // whether to normalize the resulting position within the size of the canvas
		
		condition: undefined,		
		on_position_changed: undefined,
				
		trace: false,
	};
	
	props = init_props_old(_props);
	resources = _resources;
	
	
	static canStart = function(source_data) {
		return true;
	}
	
	static start = function(source_data, event, source_item) {
		
		// NOTE: assumes initiating event is a mouse button event
		button = event[$ "button"];
		if button == undefined button = mb_left;
		
		// TODO: init_props on the parameters (and define defaults in .yui)
		parameters = variable_struct_get(event, "parameters") ?? {};
		
		on_position_changed = parameters[$ "on_position_changed"] ?? props.on_position_changed;
				
		// NOTE: assumes parent is a canvas!
		target = source_item;
		canvas = source_item.parent;
		position = {
			left: 0,
			top: 0,
		};
		
		return undefined;
	}
	
	static update = function(visual_item, cursor_pos) {
		
		var canvas_size = canvas.used_layout_size;
		
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

		yui_handle_event(on_position_changed, target.data_context, target, [position]);
		
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
		canvas = undefined;
		position = undefined;
		on_position_changed = undefined;		
	}
}