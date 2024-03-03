/// @description here
function YuiLayoutBase(alignment, spacing) constructor {
	self.alignment = alignment;
	self.spacing = spacing;
	
	static resize = function(width, height) {
		// no default behavior
	}
	
	static inspectron = Inspectron()
		.Checkbox(nameof(trace))
		.Include(nameof(alignment))
		.Watch(nameof(spacing)) // TODO int slider
		.Rect(nameof(available_size))
		.Rect(nameof(draw_size))
		.Rect(nameof(viewport_size))
}