/// @description adds a tooltip hotspot if there is a tooltip defined
function yui_render_tooltip_if_any(ro_context, tooltip_rect, props, data, item_index) {
	if props.tooltip != noone {
		if !variable_struct_exists(self, "tooltip_renderer") {
			yui_warning("no tooltip renderer for props -- is this a template definition root?");
		}
		
		ro_context.addHotspot(tooltip_rect, self, onTooltip, props.trace, data, item_index);
	}
}