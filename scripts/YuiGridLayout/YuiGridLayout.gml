/// @description
function YuiGridLayout(alignment, spacing) : YuiLayoutBase(alignment, spacing) constructor {
	static is_live = false;

	// elements may use this to calculate their own draw size
	self.draw_size = undefined;
	
	// the settings for this grid instance
	self.settings = undefined;
	
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.available_size = available_size;
		self.viewport_size = viewport_size;
		
		if !settings {
			settings = new YuiGridSettings(panel_props[$ "grid"]);
			
			rows = settings.props.rows;
			row_height = settings.props.row_height;
			row_spacing = settings.props.row_spacing;
			
			columns = settings.props.columns;
			column_width = settings.props.column_width;
			column_spacing = settings.props.column_spacing;
			
			left_to_right = settings.props.direction == "left_to_right";
		}
		
		if available_size {
			row_height ??= (available_size.h - settings.spacing_height) / rows;
			column_width ??= (available_size.w - settings.spacing_width) / columns;
		}
	}
	
	static arrange = function() {
		
		var row = 0;
		var column = 0;
		
		var row_y = available_size.y;
		var grid_bottom = 0;
		
		var i = 0; repeat array_length(items) {
			
			var item = items[i];
			
			// size the item according to the grid settings
			var possible_size = getAvailableSizeForItem(i, column, row, row_y);
			
			// arrange it within the size
			var item_size = item.arrange(possible_size, viewport_size);
			
			//yui_log($"item_size for {i} was {item_size}");
			
			var item_bottom = item_size.y + item_size.h + row_spacing;
			grid_bottom = max(grid_bottom, item_bottom);
			
			i++;
			column += 1;
			
			// bump to next row on wrap
			if column == columns {
				column = 0;
				row += 1;
				
				// the new row starts at the bottom of the previous
				row_y = grid_bottom + row_spacing;
			}
		}
		
		var grid_width = columns * (column_width + column_spacing) - column_spacing;
		var grid_height = grid_bottom - available_size.y;
		
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: grid_width,
			h: grid_height,
		};
		
		return draw_size;
	}
	
	static getAvailableSizeForItem = function(index, column, row, row_y) {
		switch left_to_right {
			case true:
				var _x = floor(available_size.x + (column * (column_width + column_spacing)));
				var _y = floor(available_size.y + (row * (row_height + row_spacing)));
				
				// happens if available_size.h is infinite
				if is_nan(_x) or _x == infinity {
					throw yui_error("Grid layout requires width to be set when used inside a viewport (scrollbox)");
				}
				
				// happens if available_size.h is infinite
				if is_nan(_y) or _y == infinity
					_y = row_y;
					
				return {
					x: _x,
					y: _y,
					w: column_width,
					h: row_height,
				};
			case false:
				throw yui_error("only left_to_right grid is currently supported");
		}
	}
	
	static inspectron = Inspectron()
		.Label(" type: grid")
		.Include(nameof(settings))
}

function YuiGridSettings(grid_settings = {}) constructor {
	
	static default_props = {
		direction: "left_to_right",
		rows: 1,
		row_height: undefined,
		row_spacing: 0,
		
		columns: 1,
		column_width: undefined,
		column_spacing: 0,
	};
	
	self.props = yui_apply_props(grid_settings);
	
	// the total h/w used by spacing
	spacing_height = (props.rows - 1) * props.row_spacing;
	spacing_width = (props.columns - 1) * props.column_spacing;
	
	static inspectron = Inspectron()
		.Watch(nameof(spacing_width))
		.Watch(nameof(spacing_height))
}