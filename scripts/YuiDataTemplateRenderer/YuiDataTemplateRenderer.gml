/// @description renders a YUI Data Template
function YuiDataTemplateRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {
		type: "data_template",
		data_type: noone,
		
		resource_group: noone, // this is the group of resources that contains the data templates
		resource_key: noone, // this is the key to look up within the group (usually bound)
		
		strict: false,
	}
	
	props = init_props_old(_props);
	props.resource_key = yui_bind(props.resource_key, _resources);
	
	category_map = yui_resolve_resource_category_map(props.resource_group, _resources)
	
	// ===== functions =====
	
	static update = function(ro_context, data, draw_rect, item_index) {
				
		// find the data key from the resource_key binding
		var resource_key = ro_context.resolveBinding(props.resource_key, data);
		
		// get the yui data from the transform as applied to the current data context
		var template_for_data = category_map[$ resource_key];
		
		// if we found a template, use it to render the data
		if template_for_data != undefined {
			
			// resolve the template props to renderers as needed (and store on the map for future use)
			if instanceof(template_for_data) == "struct" {
				var renderer = yui_resolve_renderer(template_for_data, ro_context.resources);
				category_map[$ resource_key] = renderer;
			}
			else {
				renderer = template_for_data;
			}
			
			// update the child
			var child_result = renderer.update(ro_context, data, draw_rect, item_index);
			
			// TODO?: note this data template renderer on the child somehow for debugging?
		
			// pass the child_result back up (this node behaves as the size of the template renderer)
			return child_result;
		}
		else if props.strict {
			throw "Could not find resource template from group '" +
				props.resource_group + "' with key '" + resource_key + "'";
		}
		else {
			// if we couldn't find a renderer in non-strict mode, just don't draw anything;
			return false;
		}
	}
}