/// @description creates a top level YUI document
function YuiDocument(_yui_file) constructor {
	yui_file = _yui_file;
			
	previous_animation_states = {};
	next_animation_states = {};
	
	update_result = undefined;
	
	cursor_event_consumed = false;
	
	// for the loaded document
	default_props = {
		id: noone,
		data_type: noone,
		import: [], // list of .resource.yui filepaths relative to the yui_folder
		resources: {},
		root: noone,
	}
	
	static loadDocument = function() {
		
		if !file_exists(yui_file) {
			yui_error("Could not find yui document file at", yui_file);
		}
		yui_log("loading yui_file:", yui_file);
		
		// load the file data from disk
		var file_text = string_from_file(yui_file);
		var file_data = snap_from_yaml(file_text);
		
		// apply default props
		loaded_files = [yui_file];
		
		// TODO: need to fix yui_init_props...
		yui_document = yui_init_props(file_data, default_props);
		
		// resolve imports
		var yui_folder = filename_dir(yui_file);		
		resources = yui_resolve_resource_imports(
			yui_document.resources,
			yui_document.import,
			yui_folder,
			trackLoadedFile);
		
		// resolve root renderer
		root_renderer = yui_resolve_renderer(yui_document.root, resources, yui_document.id);		
	}
	
	static trackLoadedFile = function(filepath) {
		loaded_files[array_length(loaded_files)] = filepath;
	}
	
	static update = function(data_context, draw_rect) {
				
		render_context = new YuiRenderContext(resources, self);
		
		previous_animation_states = next_animation_states;
		
		update_result = root_renderer.update(render_context, data_context, draw_rect, undefined);
		
		if YuiCursorManager.active_interaction != undefined {
			// update game objects that participate in the interaction
			yui_handle_game_object_interaction(YuiCursorManager.active_interaction, render_context);
		}
		
		// hack
		_draw_rect = draw_rect;
	}
	
	static handleHotspots = function(cursor_pos, cursor_event) {
		if !update_result return;		
		
		// hack
		_cursor_pos = cursor_pos;
				
		// hack
		var render_size = update_result;

		// this tracks whether the document consumed a mouse input
		if !YuiCursorManager.cursor_event_consumed
		{
			cursor_event_consumed = render_context.handleAllHotspots(cursor_pos, cursor_event);
			
			// check if the root document should consume the cursor event
			if !cursor_event_consumed && root_renderer.props.cursor_events == YuiCursorEvents.auto {
				
				//// HACK - fix mouse events not being consumed if panel content doesn't fill full panel
				//if instanceof(root_renderer) == "YuiPanelRenderer"
				//	&& root_renderer.props.size != "content"
				//	&& render_size.w != 0
				//	&& render_size.h != 0 {
				//	render_size.w = _draw_rect.w;
				//	render_size.h = _draw_rect.h;
				//}
				
				if yui_cursor_in_rect(cursor_pos, update_result) {
					cursor_event_consumed = true;
				}				
			}
			
			cursor_event.all_consumed = cursor_event_consumed;
			YuiCursorManager.cursor_event_consumed = cursor_event_consumed;
			
			if mouse_check_button_released(mb_left) {
				yui_log("screen", yui_file, "mouse consume result", cursor_event_consumed);
			}
		}
	};
	
	static draw = function() {
		if !update_result return;
		update_result.draw();
			
		// render overlays
		render_context.drawOverlays();

		// handle interaction
		if YuiCursorManager.active_interaction != undefined {
			
			// TODO: how do we move the cursor handling to handleHotspots()?
			// move the update portion to the main update?
			
			// update and draw
			var interaction_result = YuiCursorManager.active_interaction.update(render_context, _cursor_pos);
			if interaction_result {
				interaction_result.draw();
			}
			
			// reset interaction frame data (if it's still active)
			if YuiCursorManager.active_interaction {
				YuiCursorManager.active_interaction.resetFrame();
			}
		}
	}
	
	loadDocument();
}