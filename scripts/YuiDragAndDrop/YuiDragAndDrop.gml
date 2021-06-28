/// @description here
function YuiDragAndDrop(_props, _resources) constructor {
		
	static default_props = {
		id: undefined,
		type: "drag_and_drop",
		
		drag: {
			condition: undefined,
			visual: undefined,
			action: undefined
		},
		drop: {
			condition: undefined,
			visual: undefined,
			action: undefined
		},
		
		on_cancel: undefined,
		
		trace: false,
	};
	
	props = init_props_old(_props);
	
	props.drag.condition = yui_bind(props.drag.condition, _resources);
	drag_renderer = yui_resolve_renderer(props.drag.visual, _resources);
	
	props.drop.condition = yui_bind(props.drop.condition, _resources);
	drop_renderer = yui_resolve_renderer(props.drop.visual, _resources);
	
	static canStart = function(ro_context, source_data) {
		if props.drag.condition != undefined {
			// TODO condition array?		
			return ro_context.resolveBinding(props.drag.condition, source_data);		
		}
		else {
			return true;
		}
	}
	
	static start = function(source_data, source_element, event) {
		// NOTE: assumes initiating event is a mouse button event
		var button = event[$ "button"];
		if button == undefined button = mb_left;
		
		source = {
			data: source_data,
			button: button,
		};
		target = {
			data: undefined,
			hover: undefined,
			can_drop: undefined,
		};
	}
	
	// update drag visual
	// NOTE: executed after updateTarget!
	static update = function(ro_context, cursor_pos) {
		
		// draw indicator in portion of screen offset from cursor position
		var draw_rect = {
			x: cursor_pos.x,
			y: cursor_pos.y,
			w: ro_context.screen_size.w,
			h: ro_context.screen_size.h,
		};
		
		var interaction_data = {
			source: source,
			target: target,
		};
		
		var result = drag_renderer.update(ro_context, interaction_data, draw_rect, undefined);
				
		// end drag on mouse up
		if !mouse_check_button(source.button) {			
			if target.can_drop {
				yui_call_event_handler(props.drop.action, self, ro_context, interaction_data);
			}
			else {
				yui_call_event_handler(props.on_cancel, self, ro_context, interaction_data);
			}
			finish();
		}
		
		if result {
			// center result on cursor
			result.finalize(-result.w / 2, -result.h / 2);			
			return result;
		}
		else 
			return false;
	}
	
	static updateTarget = function(ro_context, target_data, target_rect, target_participation, item_index) {
		var is_drop = target_participation[$ "drop"] == true;
		if is_drop {			
			ro_context.addHotspot(
				target_rect,
				self,
				onHover,
				props.trace,
				target_data,
				item_index);
		}
	}
	
	static onHover = function(hotspot, cursor_state, cursor_event) {
		if cursor_event.hover_consumed return;
		
		interaction_data = {
			source: source,
			target: { // this is customized per target, so that each renderer gets correct data
				data: hotspot.data,
				hover: cursor_state.hover,
			},
		};
		
		var is_valid_drop = canDrop(hotspot.ro_context, interaction_data);
		interaction_data.target.can_drop = is_valid_drop;
		
		if cursor_state.hover {
			cursor_event.hover_consumed = true;
			// TODO: something is breaking here when yui_screen.frame_cadence > 1
			// somehow the target isn't getting set?
			// I think the issue is that the hotspot handler runs and the main update
			// needs to run immediately after that in that case
			// because of interaction.resetFrame();
			target.hover = true;
			
			// only set this for the interaction when the drop is valid
			if is_valid_drop {
				target.can_drop = true;
				target.data = hotspot.data;
			}
		}
		
		// FUTURE: enable state logic to run before draw, so all renderers have final state
		// (currently only the drag visual has final state since it's executed last)
			
		if drop_renderer {
			hotspot.result = drop_renderer.update(
				hotspot.ro_context,
				interaction_data,
				hotspot.rect,
				hotspot.item_index);
		}
	}
	
	static canDrop = function(ro_context, data) {
		
		// TODO condition array?
		
		var can_drop = ro_context.resolveBinding(props.drop.condition, data);
		return can_drop;
	}
	
	static resetFrame = function() {		
		target.data = undefined;
		target.hover = undefined;
		target.can_drop = undefined;
	}
	
	static finish = function() {
		// TODO: document.endInteraction();
		YuiCursorManager.active_interaction = undefined;
		document = undefined;
		source = undefined;
		target = undefined;
	}
}