/// @description renders YUI text
function YuiTextElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	
	static scribble_enabled = yui_check_scribble();
	
	static default_props = {
		type: "text",
		padding: 0,
		
		scribble: false, // whether to use scribble to draw the text
		
		text: undefined,
		text_format: undefined,
		
		text_style: "body",
		font: undefined, // overrides text_style.font
		color: undefined, // overrides text_style.color
		highlight_color: undefined,
		
		// these require scribble: true
		autotype: undefined, // simple option to enable typist.in()
		typist: undefined, // controls typewriter behavior
		regions: false, // whether region features are enabled at all
		region_color: undefined, // highlight color when a region is active
		region_blend: 1, // blend amount for highlighted region
	};
	
	static default_events = {
		on_region_hover_changed: undefined, // event for when a region is hovered (or no longer hovered)
	}
	
	props = yui_apply_element_props(_props);
	
	baseInit(props, default_events);
	
	props.events.on_region_hover_changed = yui_bind_handler(props.events.on_region_hover_changed, resources, slot_values);
	
	if !scribble_enabled && (props.scribble || props.typist || props.autotype) {
		throw yui_error($"Add Scribble to your project in order to use scribble features (in {props.id})");
	}
	
	if props.text_format != undefined {
		yui_warning($"text.text_format is deprecated and will be removed in the future (in {props.id})");
	}
		
	
	props.text = yui_bind(props.text, resources, slot_values);
	props.typist = yui_bind(props.typist, resources, slot_values);
	props.padding = new YuiPadding(yui_bind(props.padding, resources, slot_values));
	
	// look up the text style by name from the theme
	text_style = theme.text_styles[$ props.text_style];
		
	color = yui_bind(props.color ?? text_style.color, resources, slot_values);
	is_color_live = yui_is_live_binding(color);
	if !is_color_live {
		color = yui_resolve_color(color);
	}
	
	highlight_color = yui_resolve_color(yui_bind(props.highlight_color, resources, slot_values));
	
	font = props.font ?? text_style.font;
	if yui_is_binding(font) {
		font = font.resolve();
	}
	if !is_string(font) {
		throw yui_error("Expecting font name");
	}
	
	// assume regions are enabled when region color is set
	if props.region_color != undefined props.regions = true
	props.region_color = yui_resolve_color(props.region_color);
	
	is_text_live = yui_is_live_binding(props.text);
	
	// check if text is an array with bindings
	if is_array(props.text) {
		var i = 0; repeat array_length(props.text) {
			var text_item = props.text[i];
				
			// update binding expression to YuiBinding in place
			if yui_is_binding_expr(text_item) {
				is_text_live = true;
				var binding = yui_bind(text_item, resources, slot_values)
				props.text[i] = binding;
			}	
			i++;
		}
	}
	
	is_typist_live = yui_is_live_binding(props.typist);
	
	is_bound = base_is_bound
		|| is_text_live
		|| is_color_live
		|| is_typist_live;
		
	// ===== functions =====
	
	static getLayoutProps = function() {
		var halign = alignment.h == "center"
			? fa_center
			: fa_left
			
		var valign = alignment.v == "center"
			? fa_middle
			: fa_top
		
		return {
			padding: props.padding,
			size: size,
			halign: halign,
			valign: valign,
			highlight_color: highlight_color,
			use_scribble: props.scribble,
			autotype: props.autotype,
			regions: {
				enabled: props.regions,
				highlight: props.region_color != undefined,
				color: props.region_color,
				blend: props.region_blend,
			},
		};
	}

	// feather ignore once GM2017
	static getBoundValues = function YuiTextElement_getBoundValues(data, prev) {
		var text = is_text_live && !is_array(props.text) ? props.text.resolve(data) : props.text;
		if text == undefined {
			return false;
		}
		
		// handle text array by joining the values		
		if is_array(text) {
			var joined_text = "";
			var i = 0; repeat array_length(text) {
				var item_text = yui_resolve_binding(text[i++], data);
				joined_text += string(item_text);
			}
			text = joined_text;
		}
			
		if props.text_format != undefined
		{
			text = string_replace(props.text_format, "{0}", text);
		}
		
		var typist = is_typist_live ? props.typist.resolve(data) : props.typist;
		
		if props.trace
			DEBUG_BREAK_YUI
		
		// diff
		if prev
			&& text == prev.text
			&& typist == prev.typist
		{
			return true;
		}
		
		var values = {
			is_live: is_bound,
			text: text,// ?? "",
			font: font,
			typist: typist,
		};
		
		return values
	}
}