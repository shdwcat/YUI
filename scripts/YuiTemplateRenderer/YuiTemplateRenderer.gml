/// @description renders a template definition
function YuiTemplateRenderer(_props, _resources, _template_definition) constructor {
	static default_props = {
		id: "", // unique ID for this element, required to enabled animations and other effects
		item_key: noone, // identifies an element in an array (must bind to unique value on data!)
		trace: false,
		data_source: undefined,
	}	
	
	props = init_props_old(_props);
				
	// defines what input slots the template supports
	slots = _template_definition[$ "slots"];
	if slots == undefined slots = {};
	
	template = snap_deep_copy(_template_definition.template);
		
	// TODO: switch this to run in update() so that it doesn't stomp the definition data_source
	if props.data_source != undefined {
		template.data_source = props.data_source;
	}
	
	// copy template input props into slots, or onto the template renderer props if there isn't a slot
	slot_inputs = yui_init_slot_inputs(slots, _props, template);	
	
	template_renderer = yui_resolve_renderer(template, _resources);
	
	props.cursor_events = YuiCursorEvents.auto;
		
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
		
		// TODO: add slots as additional update argument to avoid context copying
		
		var template_context = ro_context.copy();
		
		// TODO: actually we want to apply the new ones on the old ones
		// in order to support nested templates!
		template_context.slot_inputs = slot_inputs;
		
		var template_result = template_renderer.update(template_context, data, draw_rect, item_index)
		
		return template_result;
	}
}