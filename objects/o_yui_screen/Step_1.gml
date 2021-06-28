/// @description check for reload
		
if YuiGlobals.runner_temp_folder != noone {
	var got_focus = false;
	var _lost_focus = !window_has_focus();
	if _lost_focus {
		// track that focus was lost
		lost_focus = true;
	}
	else if lost_focus {
		// reset once focus is back
		var got_focus = true;
		lost_focus = false;
	}			
		
	var should_reload = got_focus;		
	if should_reload {		
		
		try {
			// refresh data files
			var file_count = array_length(yui_document.loaded_files);
			var i = 0; repeat file_count {
				var filepath = yui_document.loaded_files[i];
			
				// delete the temp copy and re-copy it from data files
				var temp_file = YuiGlobals.runner_temp_folder + filepath;
				file_delete(temp_file);
			
				var data_file = global.__yui_globals.debug_config.project_data_folder + filepath;
				file_copy(data_file, temp_file);
					
				i++;
			}
			
			// TODO: make this happen once per reload
			YuiCursorManager.interaction_map = yui_load_interactions();
		
			yui_document.loadDocument();
		}
		catch (error) {
			yui_log("Error reloading YUI file '", yui_file, "':", error);
		}
	}
}
