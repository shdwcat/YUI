
function YuiGridLayout() : YuiLayoutBase() constructor {
	
	static default_props = {
		direction: "left_to_right",
		rows: 1,
		columns: 1,
		row_spacing: 0,
		column_spacing: 0,
	};
	
	alignment = { 
		vertical: "stretch",
		horizontal: "stretch",
	};
	maximum_width = 0;
	
	// TODO: make an override() helper to avoid the recursion bug!
	static base_init = init;
	static init = function(_draw_rect, size, panel) {
		var draw_rect = base_init(_draw_rect, size, panel);
		
		props = init_props_old(panel[$ "grid"]);
		
		spacing_height = (props.rows - 1) * props.row_spacing;
		row_height = (current_draw_rect.h - spacing_height) / props.rows;
		
		spacing_width = (props.columns - 1) * props.column_spacing;
		column_width = (current_draw_rect.w - spacing_width) / props.columns;
		return draw_rect;
	}
	
	// static base_getItemDrawRect = getItemDrawRect;
	static getItemDrawRect = function(item_index, item_props) {
		
		switch props.direction {
			case "left_to_right":
				var column = item_index mod props.columns;
				var row = floor(item_index / props.columns);
				return {
					x: draw_rect.x + (column * (column_width + props.column_spacing)),
					y: draw_rect.y + (row * (row_height + props.row_spacing)),
					w: column_width,
					h: row_height,
				};
		}
	}

	static update = function(item_render_size, spacing) {
		// nothing to do here because grid is precomputed
		return true;
	};
	
	static complete = function() {
		return draw_rect;
	};
}