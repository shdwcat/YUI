/// @description here
function YuiDragAndDrop(_props, _resources) constructor {
		
	static default_props = {
		id: undefined,
		type: "drag_and_drop",
		trace: false,
		
		drag: {
			condition: undefined,
			center_visual: true,
			visual: undefined,
			action: undefined
		},
		drop: {
			condition: undefined,
			visual: undefined,
			action: undefined
		},
		
		on_cancel: undefined,
	};
	
	props = yui_init_props(_props);
	resources = _resources;
	
	props.drag.condition = yui_bind(props.drag.condition, resources, undefined);
	drag_element = yui_resolve_element(props.drag.visual, resources, undefined);
	props.drag.action = yui_bind_handler(props.drag.action, resources, undefined);
	
	drop_hash_id = YuiCursorManager.participation_hash.getStringId(props.id + ".drop");
	props.drop.condition = yui_bind(props.drop.condition, resources, undefined);
	drop_element = yui_resolve_element(props.drop.visual, resources, undefined);
	props.drop.action = yui_bind_handler(props.drop.action, resources, undefined);
	
	props.on_cancel = yui_bind_handler(props.on_cancel, resources, undefined);
	
	
	static canStart = function(source_data) {
		if props.drag.condition != undefined {
			// TODO condition array?
			return yui_resolve_binding(props.drag.condition, source_data);
		}
		else {
			return true;
		}
	}
	
	static start = function(source_data, event, source_item) {
		// NOTE: assumes initiating event is a mouse button event
		var button = event[$ "button"] ?? mb_left;
		
		// need to be able to use button constants in .yui files
		// which probably mean we need a YuiEventHandler class to grab the constant from the "mb_left" etc
		//button ??= mb_left;
		
		source = {
			data: source_data,
			event: { // TODO: include x/y in button event and pass directly
				x: device_mouse_x_to_gui(0),
				y: device_mouse_y_to_gui(0),
				world_x: mouse_x,
				world_y: mouse_y,
				button: button,
			},
		};
		
		// this is the resolved target of the interaction,
		// aka the one thing we're hovering over (if any)
		target = {
			data: undefined,
			hover: undefined,
			can_drop: undefined,
		};
		
		cursor = {
			x: device_mouse_x_to_gui(0),
			y: device_mouse_y_to_gui(0),
			world_x: mouse_x,
			world_y: mouse_y,
		};
		
		return drag_element;
	}
	
	static update = function(visual_item, cursor_pos) {
		
		// resets target state
		resetFrame();
		
		cursor.x = device_mouse_x_to_gui(0);
		cursor.y = device_mouse_y_to_gui(0);
		cursor.world_x = mouse_x;
		cursor.world_y = mouse_y;
				
		var interaction_data = {
			source: source,
			target: target,
			cursor: cursor,
		};
		
		// TODO: factor the participation stuff into base class or helper functions!
		// it's way too clunky currently
		
		// evaluate the instances in the 'drop' role
		var targets = yui_get_interaction_participants(drop_hash_id);
		var i = 0; repeat array_length(targets) {
			var drop_item = targets[i++];
			updateDropTarget(drop_item);
		}
		
		// position the visual at the mouse cursor
		if visual_item {
			var xdiff = cursor_pos.x - visual_item.x;
			var ydiff = cursor_pos.y - visual_item.y;
			
			if props.drag.center_visual {
				// center result on cursor
				xdiff -= visual_item.draw_size.w / 2;
				ydiff -= visual_item.draw_size.h / 2;
			}
			
			visual_item.move(xdiff, ydiff);
		}
				
		// end drag on mouse up
		var button_down = mouse_check_button(source.event.button); // TODO button
		if !button_down {
			if target.can_drop {
				yui_call_handler(props.drop.action, , interaction_data);
			}
			else {
				yui_call_handler(props.on_cancel, , interaction_data);
			}
			finish();
			return false;
		}
		
		// optionally run an action every frame
		if props.drag.action {
			yui_call_handler(props.drag.action, , interaction_data);
		}
	}
	
	static updateDropTarget = function(drop_item /* yui_cursor_item */) {
		
		var is_gui_item = object_is_ancestor(drop_item.object_index, yui_base);
		
		// if it's not a yui_base, use the item itself as the data
		var drop_data = is_gui_item
			? drop_item.data_context
			: drop_item;
		
		var drop_target = {			
			data: drop_data,
			hover: drop_item.highlight,
		};
		
		
		// NOTE: a drop_element is currently required!
		
		var interaction_data = undefined;
		if drop_item.interaction_item == undefined {
			interaction_data = {
				source: source,
				target: drop_target,
			};
			drop_target.can_drop = canDrop(interaction_data);
			
			with drop_item {
				interaction_item = yui_make_render_instance(other.drop_element, interaction_data, , 100);
				
				// align drop visual to game position
				if !is_gui_item {
					var xdiff = yui_world_to_gui_x(x) - interaction_item.x;
					var ydiff = yui_world_to_gui_y(y) - interaction_item.y;
					interaction_item.move(xdiff, ydiff);
				}
				else {
					interaction_item.arrange(drop_item.draw_size);
				}
			}
		}
		else {
			// grab the interaction_data from the interaction_visual's data_context
			interaction_data = drop_item.interaction_item.data_context;
		}
		
		// TODO: move the visual to the target?? only matters if the target is moving
		
		// check if this target is a valid drop
		drop_target.can_drop = canDrop(interaction_data);
		
		// only set this for the interaction when the drop is valid
		if drop_target.can_drop && drop_target.hover {			
			target.data = drop_data;	
			target.can_drop = true;		
		}
	}
	
	static canDrop = function(data) {
		if props.drop.condition == undefined return true;
		// TODO condition array?
		
		var can_drop = yui_resolve_binding(props.drop.condition, data);
		return can_drop;
	}
	
	static resetFrame = function() {		
		target.data = undefined;		
		target.hover = undefined;
		target.can_drop = undefined;
	}
	
	static finish = function() {
		// clean up drop visuals
		var targets = yui_get_interaction_participants(drop_hash_id);
		var i = 0; repeat array_length(targets) {
			var drop_item = targets[i++];
			instance_destroy(drop_item.interaction_item);
			drop_item.interaction_item = undefined;
		}
		
		YuiCursorManager.finishInteraction();
		source = undefined;
		target = undefined;
		cursor = undefined;
	}
}