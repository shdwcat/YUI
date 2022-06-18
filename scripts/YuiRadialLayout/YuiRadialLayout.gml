/// @description Arranges item in a radial layout
function YuiRadialLayout(alignment, spacing) constructor {
	static is_live = false;

	// NOTE: not relevant to this layout
	//self.alignment = alignment;
	//self.spacing = spacing;
	
	// elements may use this to calculate their own draw size
	self.draw_size = undefined;
	
	// the settings for this radial instance
	self.settings = undefined;
	
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.item_count = array_length(items);
		self.available_size = available_size;
		self.viewport_size = viewport_size;
		
		if !settings {
			settings = new YuiRadialSettings(panel_props[$ "radial"]);
			
			// TODO: set is_live if radial settings are bound
		}
	}
	
	static arrange = function() {
		
		if item_count > 0 {
			var center_x = available_size.x + (available_size.w / 2);
			var center_y = available_size.y + (available_size.h / 2);
			
			// optimize
			var item_w = settings.props.item_size.w;
			var item_h = settings.props.item_size.h;
			var arc_start = settings.arc_start
		
			// use the shorter length of the rectangle as the radius
			// (does not support ellipse math)
			var radius = min(available_size.w, available_size.h) / 2;
			
			var distance_to_item_center = radius - settings.item_radius;
			
			if settings.is_arc {
				// arc starts at 0, so there are count-1 segments between 0 and the end
				var arc_segment = settings.props.arc / (item_count - 1);
			}
			else {
				// for a circle, divide it up evenly between the items
				var arc_segment = 360 / item_count;
			}
		
			var i = 0; repeat array_length(items) {
			
				var item = items[i];
									
				// calculate the center position of the item
				var angle = arc_start + (arc_segment * i);
				var _x = center_x + lengthdir_x(distance_to_item_center, angle);
				var _y = center_y + lengthdir_y(distance_to_item_center, angle);
				
				// center the item size on the calculated position
				var possible_size = {
					x: round(_x - (item_w / 2)),
					y: round(_y - (item_h / 2)),
					w: item_w,
					h: item_h,
				};
				
				// arrange it
				var item_size = item.arrange(possible_size, viewport_size);
				
				i++;
			}
		}
		
		// radial (currently) always fills the available space
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: available_size.w,
			h: available_size.h,
		};
		
		return draw_size;
	}
}

function YuiRadialSettings(radial_settings = {}) constructor {
	
	static default_props = {
		arc: undefined,
		center_arc: false, // when true, the middle of the arc will face the radial direction
		direction: 0, // angle where the arc starts, 0 means right
		
		item_size: undefined, // the size of the items in the radial (required)
	};
	
	props = yui_apply_props(radial_settings);

	if is_numeric(props.item_size)
	{
		var size = props.item_size;
		props.item_size = { w: size, h: size };
	}
	
	is_arc = props.arc != undefined;
	if is_arc {	
		// angle where the arc starts
		arc_start = props.center_arc
				? props.direction + (props.arc / 2)
				: props.direction;
	}
	else {
		arc_start = props.direction;
	}
	
	// the maximum width of the item_size on any angle
	item_radius = point_distance(0, 0, props.item_size.w, props.item_size.h) / 2;
	
	// TODO: would be nice for arc and direction to be bindable perhaps?
}