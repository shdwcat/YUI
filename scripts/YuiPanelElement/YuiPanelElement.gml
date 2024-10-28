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
		template: undefined, // the template to use when rendering elements from the path
		
		// child elements (and sub-children will be indexed by their positiin in this panel
		// NOTE: setting 'indexed: true' on a sub-panel will replace this index
		// NOTE: does not work for template mode
		indexed: false,
		
		// allows binding slots at panel scope instead of item scope
		bind_slot_scope: undefined,
	};
	
	props = yui_apply_element_props(_props);
	
	has_scoped_slots = props.bind_slot_scope != undefined;
	if has_scoped_slots {
		slot_values = slot_values.extendWith();
		var bound_slot_names = variable_struct_get_names(props.bind_slot_scope);
		var i = 0; repeat array_length(bound_slot_names) {
			var slot_name = bound_slot_names[i++];
			var binding = yui_bind(props.bind_slot_scope[$ slot_name], resources, slot_values);
			
			if is_instanceof(binding, YuiScopeBinding) {
				throw yui_error("binding scope multiple times");
			}
			
			var scoped_binding = new YuiScopeBinding(binding);
			slot_values.set(slot_name, scoped_binding);
		}
	}
	
	baseInit(props);
	
	elements = yui_bind(props.elements, resources, slot_values);
	
	// live binding this is not (yet?) supported, but this enables $slot support
	layout_type = yui_bind(props.layout, resources, slot_values);
	
	count = yui_bind_and_resolve(props.count, resources, slot_values);
	reverse = yui_bind_and_resolve(props.reverse, resources, slot_values);
	
	var make_layout = yui_resolve_layout(layout_type);
	layout = new make_layout(alignment, props.spacing, size);
	layout.trace = props.trace;
	
	resolveBackgroundAndBorder();
	
	uses_template = props.template != undefined;
	
	if uses_template {
		if props.elements == undefined throw "cannot use 'template' without 'elements'";
		
		item_element = yui_resolve_element(props.template, resources, slot_values, props.id + ":T");
	}
	else {
		// generate item_elements if we have explicit elements
		item_elements = [];
		var i = 0; var panel_count = array_length(elements); repeat panel_count {
			var element = elements[i];
			var panel_item_id = props.id + "[" + string(i) + "]";
			var item_slot_values = slot_values;
			
			// when indexing is enabled, set the $panel_index and $panel_count slots
			if props.indexed {
				item_slot_values = slot_values.extendWith({
					panel_index: i,
					panel_count: panel_count,
				});
			}
			
			item_elements[i] = yui_resolve_element(
				element,
				resources,
				item_slot_values,
				panel_item_id);
				
			i++;
		}
		element_count = i;
		
		// force layout to check if it's live
		layout.init(item_elements, undefined, undefined, props);
	}
	
	is_elements_bound = yui_is_live_binding(elements);
	
	is_bound = base_is_bound
		|| is_elements_bound;
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		
		return {
			alignment,
			padding,
			size,
			layout,
			reverse,
			count,
			// border
			border_color,
			border_thickness: props.border_thickness,
			border_focus_color,
		};
	}
	
	// feather ignore once GM2017
	static getBoundValues = function YuiPanelElement_getBoundValues(data, prev) {
		// update scoped bindings if needed
		if has_scoped_slots && (!prev || data != prev.data_source) {
			var bound_slot_names = variable_struct_get_names(props.bind_slot_scope);
			var i = 0; repeat array_length(bound_slot_names) {
				var slot_name = bound_slot_names[i++];
				var binding = slot_values.get(slot_name);
				binding.updateScope(data);
			}
		}
		
		if uses_template {
			// single template element for bound data_items
			var source_items = is_elements_bound ? self.elements.resolve(data) : self.elements;
			
			if !is_array(source_items) {
				if data == undefined
					throw yui_error("unable to resolve 'elements' to an array - data_context was undefined, check that your data_context has been created before the yui_document that references it");
				else
					throw yui_error("'elements' must resolve to an array");
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
		
		var live_item_values = layout.is_live
			? layout.getLiveItemValues(data, prev)
			: undefined;
		
		// diff
		if prev
			&& data == prev.data_source
			&& child_count == prev.child_count
			&& (uses_template
				? array_equals(data_items, prev.data_items)
				: data_items == prev.data_items)
			&& (!layout.is_live || live_item_values == true)
		{
			return true;
		}
		
		return {
			is_live: is_bound || layout.is_live,
			// border
			data_source: data,
			// panel
			child_count: child_count,
			data_items: data_items,
			liveItemValues: live_item_values,
		};
	}
}