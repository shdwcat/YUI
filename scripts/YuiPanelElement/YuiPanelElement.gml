/// @description renders a YUI Panel
function YuiPanelElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "panel",
		
		// layout
		layout: "vertical",
		reverse: false, // when true, shows items in reverse order
		count: undefined, // max number of items to show (applies after reverse)
		padding: 0,
		spacing: undefined,
		alignment: "default",
		// alignment is a struct with two properties:
		// .vertical:"top"|"bottom"|"stretch" - "center" not yet supported
		// .horizontal:"left"|"right"|"stretch" - "center" not yet supported
		
		// visuals
		background: undefined,
		border_color: undefined,
		border_thickness: 1,
		border_focus_color: undefined,
		
		// option A: explicitly list the elements in the panel
		elements: undefined,
		
		// option B: bind the element list to data, and use a template to render each element
		path: undefined, // defines the source path for the element list
		template: undefined, // the template to use when rendering elements from the path
		
		// allows binding slots at panel scope instead of item scope
		bind_slot_scope: undefined,
	};
	
	props = yui_apply_element_props(_props);
	
	has_scoped_slots = props.bind_slot_scope != undefined;
	if has_scoped_slots {
		slot_values = yui_shallow_copy(slot_values);
		var bound_slot_names = variable_struct_get_names(props.bind_slot_scope);
		var i = 0; repeat array_length(bound_slot_names) {
			var slot_name = bound_slot_names[i++];
			var binding = yui_bind(props.bind_slot_scope[$ slot_name], resources, slot_values);
			
			if instanceof(binding) == "YuiScopeBinding" {
				throw yui_error("binding scope multiple times");
			}
			
			var scoped_binding = new YuiScopeBinding(binding);
			slot_values[$ slot_name] = scoped_binding;
		}
	}
	
	baseInit(props);
	
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	
	props.elements = yui_bind(props.elements, resources, slot_values);
	
	// live binding this is not (yet?) supported, but this enables $slot support
	props.layout = yui_bind(props.layout, resources, slot_values);
	
	props.count = yui_bind_and_resolve(props.count, resources, slot_values);
	
	var makeLayout = yui_resolve_layout(props.layout);
	layout = new makeLayout(alignment, props.spacing, size);
	layout.trace = props.trace;
	
	resolveBackgroundAndBorder()
	
	uses_template = props.template != undefined;
	
	if uses_template {
		if props.elements == undefined throw "cannot use 'template' without 'elements'";
		
		item_element = yui_resolve_element(props.template, resources, slot_values, props.id + ":T");
	}
	else {
		// generate item_elements if we have explicit elements
		item_elements = [];
		var i = 0; repeat array_length(props.elements) {
			var element = props.elements[i];
			var panel_item_id = props.id + "[" + string(i) + "]";
			item_elements[i] = yui_resolve_element(element, resources, slot_values, panel_item_id);
			i++;
		}
		element_count = i;
		
		// force layout to check if it's live
		layout.init(item_elements, undefined, undefined, props);
	}
	
	is_elements_bound = yui_is_live_binding(props.elements);
	
	is_bound = base_is_bound
		|| is_bg_sprite_live
		|| is_bg_color_live
		|| is_elements_bound;
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			layout: layout,
			reverse: props.reverse,
			count: props.count,
			// border
			is_bg_live: is_bg_sprite_live || is_bg_color_live,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			border_focus_color: border_focus_color,
		};
	}
	
	static getBoundValues = function YuiPanelElement_getBoundValues(data, prev) {
		// update scoped bindings if needed
		if has_scoped_slots && (!prev || data != prev.data_source) {
			var bound_slot_names = variable_struct_get_names(props.bind_slot_scope);
			var i = 0; repeat array_length(bound_slot_names) {
				var slot_name = bound_slot_names[i++];
				var binding = slot_values[$ slot_name];
				binding.updateScope(data);
			}
		}
		
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		
		var bg_sprite = is_bg_sprite_live ? yui_resolve_sprite_by_name(bg_sprite_binding.resolve(data)) : undefined;
		var bg_color = is_bg_color_live ? yui_resolve_color(bg_color_binding.resolve(data)) : undefined;
		
		if uses_template {
			// single template element for bound data_items
			var source_items = is_elements_bound ? props.elements.resolve(data) : props.elements;
			
			if !is_array(source_items) {
				throw yui_error("source_items must resolve to an array");
			}
			
			// we need to copy the array for diff detection to work
			var child_count = array_length(source_items);
			var data_items = array_create(child_count);
			array_copy(data_items, 0, source_items, 0, child_count);
		}
		else {
			// explicit elements bound to panel.data_context
			var child_count = element_count;
			var data_items = data;
		}
		
		var liveItemValues = layout.is_live
			? layout.getLiveItemValues(data, prev)
			: undefined;
		
		// diff
		if prev
			&& data == prev.data_source
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
			&& bg_sprite == prev.bg_sprite
			&& bg_color == prev.bg_color
			&& child_count == prev.child_count
			&& (uses_template
				? array_equals(data_items, prev.data_items)
				: data_items == prev.data_items)
			&& (!layout.is_live || liveItemValues == true)
		{
			return true;
		}
		
		return {
			is_live: is_bound || layout.is_live,
			// border
			data_source: data,
			xoffset: xoffset,
			yoffset: yoffset,
			// live versions
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			// panel
			child_count: child_count,
			data_items: data_items,
			liveItemValues: liveItemValues,
		};
	}
}