/// @description renders a YUI Panel
function YuiPanelRenderer(_props, _resources, _slot_values) : YuiBaseRenderer(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "panel",
				
		// layout
		layout: "vertical",
		padding: 0,
		spacing: undefined,
		alignment: "default",
		// alignment is a struct with two properties:
		// .vertical:"top"|"bottom"|"stretch" - "center" not yet supported
		// .horizontal:"left"|"right"|"stretch" - "center" not yet supported
		
		// visuals
		bg_sprite: undefined,
		bg_color: undefined,
		border_color: undefined,
		border_thickness: 1,	
		theme: "default",
		
		// option A: explicitly list the elements in the panel
		elements: undefined,
		
		// option B: bind the element list to data, and use a template to render each element
		path: undefined, // defines the source path for the element list
		template: undefined, // the template to use when rendering elements from the path
	};
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.elements = yui_bind(props.elements, resources, slot_values);
	
	spacing = props.spacing == undefined ? theme.panel.spacing : props.spacing;
	props.padding = yui_resolve_padding(props.padding);
	
	// live binding this is not (yet?) supported, but this enables $slot support
	props.layout = yui_bind(props.layout, resources, slot_values);
	
	var makeLayout = yui_resolve_layout(props.layout);
	layout = new makeLayout(alignment, props.padding, spacing);
	
	// resolve bg_sprite
	var use_theme = props.bg_sprite == undefined && props.bg_color == undefined;
	if use_theme {
		bg_sprite = undefined;
		//bg_sprite = theme.button.bg_sprite;
	}
	else if props.bg_sprite != undefined {
		bg_sprite = yui_resolve_sprite_by_name(props.bg_sprite, _resources);
	}
	else {
		bg_sprite = undefined;
	}
	
	// resolve colors
	bg_color = yui_resolve_color(props.bg_color);
	border_color = yui_resolve_color(props.border_color);
	
	if props.template != undefined {	
		item_renderer = yui_resolve_renderer(props.template, resources, slot_values, props.id + ":T");	
	}
	else {
		// generate item_renderers if we have explicit elements
		item_renderers = [];
		var i = 0; repeat array_length(props.elements) {
			var element = props.elements[i];
			var panel_item_id = props.id + "[" + string(i) + "]";
			item_renderers[i] = yui_resolve_renderer(element, resources, slot_values, panel_item_id);
			i++;
		}
		element_count = i;
	}
	
	is_bound = yui_is_live_binding(props.elements);
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			layout: layout,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		if props.template != undefined {
			if props.elements == undefined throw "cannot use 'template' without 'elements'";
			
			// single template element for bound data_items
			var source_items = yui_resolve_binding(props.elements, data);
			var child_count = array_length(source_items);
			
			// we need to copy the array for diff detection to work
			var data_items = array_create(child_count);
			array_copy(data_items, 0, source_items, 0, child_count);
			
			var item_renderers = array_create(child_count);
			var i = 0; repeat child_count {
				item_renderers[i++] = item_renderer;
			}
		}
		else {
			// explicit elements bound to panel.data_context
			var child_count = element_count;
			var data_items = array_create(child_count);
			var i = 0; repeat child_count {
				data_items[i++] = data;
			}
			var item_renderers = self.item_renderers;
		}
		
		// diff
		if prev
			&& child_count == prev.child_count
			&& array_equals(item_renderers, prev.item_renderers)
			&& array_equals(data_items, prev.data_items)
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			// border
			data_source: data,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			// panel
			child_count: child_count,
			item_renderers: item_renderers,
			data_items: data_items,
		};
	}
}