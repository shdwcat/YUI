function YuiBaseElement(_props, _resources, _slot_values) constructor {
	static base_props = {
		id: "", // unique ID for this element, required to enabled animations and other effects
		item_key: undefined, // identifies an element in an array (must bind to unique value on data!)
		
		theme: undefined,
		
		layer: 0, // offset to apply to the layer depth
		is_cursor_layer: false, // whether the element consumes cursor events
		focusable: false, // whether the item can be focused for kb/gamepad
		autofocus: false, // whether to auto focus this item on creation (overrides previous focus)
		
		data_source: undefined, // enables overriding the data context with something else
		
		visible: true,
		opacity: 1, // 0-1, like alpha
		size: "auto", // can also be { w: val, h: val } where val can be a number or "auto" | "content"
		alignment: "default",
		xoffset: 0,
		yoffset: 0,
		
		canvas: undefined,
		flex: undefined, // default behavior is "auto"
		
		tooltip: undefined, // @bindable tooltip text/content
		tooltip_width : 500,
		tooltip_placement: YUI_PLACEMENT_MODE.BottomLeft, // where to place the tooltip
		
		trace: false, // enables various debug visuals/breakpoints/logging
		
		events: undefined,
		
		// placeholder for animation info
		animate: undefined,
		
		// array of interaction.role participation
		interactions: [], // these are defined in data!
	};
	
	// common events across elements
	static base_events = {
		on_mouse_down: undefined,
		on_mouse_up: undefined,
		on_mouse_wheel_up: undefined,
		on_mouse_wheel_down: undefined,
		on_click: undefined,
		on_double_click: undefined,
		on_arrange: undefined,
		on_got_focus: undefined,
		on_lost_focus: undefined,
		on_hover_changed: undefined,
	};
	
	// this is the type from the .yui declaration which may be a template or fragment name
	yui_type = _props.yui_type; // TODO: string hash this for faster comparison
	
	// track our template type and definition
	// NOTE: definition will be cleared after prop initialization to avoid memory bloat
	template_type = _props[$ "template_type"];
	template_def = _props[$ "template_def"];
	
	resources = _resources;
	slot_values = _slot_values;
	
	var theme_override = _props[$ "theme"];
	if theme_override != undefined {
		// grab new theme and override slot theme
		theme = yui_resolve_theme(theme_override);
		slot_values = yui_shallow_copy(slot_values);
		slot_values.theme = theme;
	}
	else {
		// grab the theme from the slot values
		theme = slot_values.theme;
	}
	
	// get the theme props for our element type
	element_theme = theme.elements[$ _props.type];
	
	static baseInit = function(props, default_events = undefined) {
	
		props.events = yui_apply_props(props.events, default_events, base_events);
		props.events.on_mouse_down = yui_bind_handler(props.events.on_mouse_down, resources, slot_values);
		props.events.on_mouse_up = yui_bind_handler(props.events.on_mouse_up, resources, slot_values);
		props.events.on_mouse_wheel_up = yui_bind_handler(props.events.on_mouse_wheel_up, resources, slot_values);
		props.events.on_mouse_wheel_down = yui_bind_handler(props.events.on_mouse_wheel_down, resources, slot_values);
		props.events.on_click = yui_bind_handler(props.events.on_click, resources, slot_values);
		props.events.on_double_click = yui_bind_handler(props.events.on_double_click, resources, slot_values);
		props.events.on_arrange = yui_bind_handler(props.events.on_arrange, resources, slot_values);
		props.events.on_got_focus = yui_bind_handler(props.events.on_got_focus, resources, slot_values);
		props.events.on_lost_focus = yui_bind_handler(props.events.on_lost_focus, resources, slot_values);
		props.events.on_hover_changed = yui_bind_handler(props.events.on_hover_changed, resources, slot_values);
	
		YuiCursorManager.participation_hash.hashArray(props.interactions);
	
		size = new YuiElementSize(yui_bind(props.size, resources, slot_values));
		size.w = yui_bind(size.w, resources, slot_values);
		size.h = yui_bind(size.h, resources, slot_values);
	
		canvas = new YuiCanvasPosition(props.canvas, resources, slot_values, props.id);
		flex = new YuiFlexValue(props.flex);
	
		// TODO: move this to YuiPanelElement?
		alignment = new YuiElementAlignment(yui_bind(props.alignment, resources, slot_values));
		
		props.visible = yui_bind(props.visible, resources, slot_values);
		props.opacity = yui_bind(props.opacity, resources, slot_values);
		props.item_key = yui_bind(props.item_key, resources, slot_values);
		props.tooltip = yui_bind(props.tooltip, resources, slot_values);
	
		props.xoffset = yui_bind(props.xoffset, resources, slot_values);
		props.yoffset = yui_bind(props.yoffset, resources, slot_values);
	
		data_source = yui_bind(props.data_source, resources, slot_values);
	
		is_data_source_live = yui_is_live_binding(data_source);
		is_visible_live = yui_is_live_binding(props.visible);
		is_opacity_live = yui_is_live_binding(props.opacity);
		is_tooltip_live = yui_is_live_binding(props.tooltip);
		is_xoffset_live = yui_is_live_binding(props.xoffset);
		is_yoffset_live = yui_is_live_binding(props.yoffset);
		
		data_source_value = new YuiBindableValue(props.data_source);
		visible_value = new YuiBindableValue(props.visible);
		opacity_value = new YuiBindableValue(props.opacity);
		
		if props.animate {
			var opacity_animation = props.animate[$"opacity"];
			if opacity_animation {
				opacity_value = new YuiAnimatedValue(opacity_value, opacity_animation);
				is_opacity_live = true;
			}
		}
	
		base_is_bound = yui_is_live_binding(data_source)
			|| is_visible_live
			|| is_opacity_live
			|| is_tooltip_live
			|| yui_is_live_binding(props.size)
			|| yui_is_live_binding(size.w)
			|| yui_is_live_binding(size.h)
			|| is_xoffset_live
			|| is_yoffset_live;
	
		tooltip_element = undefined;
	}
	
	static createTooltip = function() {
		if tooltip_element == undefined && props.tooltip != undefined {
			var tooltip_props = {
				type: "popup",
				yui_type: "popup",
				content: props.tooltip,
				placement: props.tooltip_placement,
				padding: 5,
				size: { max_w: props.tooltip_width },
			};
			// TODO: set yui_type: tooltip and use yui_resolve_element so that we can apply theme to this
			tooltip_element = new YuiPopupElement(tooltip_props, resources, slot_values);
		}
		return tooltip_element;
	}
	
	// logic shared by many controls like border/panel/button/text_input
	
	static resolveBackgroundAndBorder = function() {
	
		// don't bind values directly by default
		bg_sprite_binding = undefined;
		is_bg_sprite_live = false;
		bg_color_binding = undefined;
		is_bg_color_live = false;
		
		if props.trace
			DEBUG_BREAK_YUI
				
		// resolve background
		var background_expr = yui_bind_and_resolve(props.background, resources, slot_values);
		if background_expr != undefined {
			
			if is_struct(background_expr) {
				// a struct is used when we want to bind the background dynamically,
				// in order to differentiate between sprite indexes (which are numbers)
				// and color values (which are also numbers :()
				bg_sprite_binding = yui_bind(background_expr[$"sprite"], resources, slot_values);
				is_bg_sprite_live = bg_sprite_binding != undefined;
				bg_sprite = undefined;
				bg_color_binding = yui_bind(background_expr[$"color"], resources, slot_values);
				is_bg_color_live = bg_color_binding != undefined;
				bg_color = undefined;
			}
			else {
				// otherwise first see if the resolved value is a sprite,
				// then try as a color value if it wasn't a sprite
				var bg_spr = yui_resolve_sprite_by_name(background_expr);
				if bg_spr != undefined {
					bg_sprite = bg_spr;
					bg_color = undefined;
				}
				else {
					bg_color = yui_resolve_color(background_expr);
					bg_sprite = undefined;
				}
			}
		}
		else {
			bg_color = undefined;
			bg_sprite = undefined;
		}
	
		// resolve border
		border_color = yui_resolve_color(yui_bind_and_resolve(props.border_color, resources, slot_values));
		
		if variable_struct_exists(props, "border_focus_color") {
			border_focus_color = yui_resolve_color(yui_bind_and_resolve(props.border_focus_color, resources, slot_values));
		}
	}
}