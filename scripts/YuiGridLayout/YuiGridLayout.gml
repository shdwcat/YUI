/// @description
function YuiGridLayout(alignment, padding, spacing) constructor {
	static is_live = false;

	self.alignment = alignment;
	self.padding = padding;
	self.spacing = spacing;
	
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
		
		row_height ??= (available_size.h - settings.spacing_height) / rows;
		column_width ??= (available_size.w - settings.spacing_width) / columns;
	}
	
	static arrange = function() {
		
		var i = 0; repeat array_length(items) {
			
			var item = items[i];
			
			// size the item according to the grid settings
			var possible_size = getAvailableSizeForItem(i);
			
			// arrange it within the size
			var item_size = item.arrange(possible_size, viewport_size);
			
			i++;
		}
		
		// grid (currently) always fills the available space
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: available_size.w,
			h: available_size.h,
		};
		
		return draw_size;
	}
	
	static getAvailableSizeForItem = function(index) {		
		switch left_to_right {
			case true:
				var column = index mod columns;
				var row = floor(index / columns);
				return {
					x: available_size.x + (column * (column_width + column_spacing)),
					y: available_size.y + (row * (row_height + row_spacing)),
					w: column_width,
					h: row_height,
				};
			case false:
				throw yui_error("only left_to_right grid is currently supported");
		}
	}
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
	
	self.props = yui_init_props(grid_settings);
	
	// the total h/w used by spacing
	spacing_height = (props.rows - 1) * props.row_spacing;
	spacing_width = (props.columns - 1) * props.column_spacing;
}