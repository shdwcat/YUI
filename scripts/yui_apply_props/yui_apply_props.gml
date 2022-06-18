/// @description applies layers of props-definitions to a struct instance/// @param instance_data  - the props for this instance
/// @param [props_layer1,...] - additional props to be applied to the instance data
function yui_apply_props(instance_data) {
	
	// special casing for just instance_data, see if we have default_props and/or base_props
	if argument_count == 1 {
		var _default_props = variable_struct_get(self, "default_props");
		var _base_props = variable_struct_get(self, "base_props");
		
		return yui_apply_props(instance_data, _default_props, _base_props);
	}
			
	// set up a new struct to hold the result to avoid modifying the raw instance_data
	var result = {};
	
	var j = 0; repeat argument_count {
		var source = argument[j++];
		
		// if any layer is undefined, just skip it
		if source == undefined continue;
	
		// loop through the values in the source and add them to the result if missing
		var keys = variable_struct_get_names(source);
		var i = 0; repeat array_length(keys) {
			var key = keys[i++];
			
			var exists = variable_struct_exists(result, key);
			if !exists {
				var source_value = source[$ key];
				result[$ key] =  source_value;
			}
		}
	}
	
	return result;
}

function yui_apply_element_props(instance_data) {
	
	// TODO: it would be a lot faster to merge the theme and template props *once* rather than repeat it
	// for every instance. Doing so would mean we'd need to 'initialize' a widget definition once
	// possibly yui_resolve_element is the right place for this -- need to check instanceof and see
	// if it's been replaced by a constructor, otherwise init it.
	// BUT we'd need to do this per theme.
	
	// maybe the trick is to squash it into the template theme definition? (assuming there is one)
	// except we don't know the loaded widgets at the point...
	// maybe the theme file is there you import the widgets you want?
	// at least the ones you want to theme...
	// though that gets tricky if I want to allow private resources...
	
	// for now this seems fast enough *shrug*
	
	// templates get additional props *and* theme support
	if template_type != undefined {
		var template_theme = theme.elements[$ template_type];
		
		var template_def = self.template_def;
		
		// clear the stored definition to reduce memory bloat
		// this is stupid hack to avoid messing with the parameters of every element constructor 🙄
		self.template_def = undefined;
		
		var props = yui_apply_props(instance_data, template_theme, template_def, element_theme, default_props, base_props);
		return props;
	}
	
	return yui_apply_props(instance_data, element_theme, default_props, base_props);
}



