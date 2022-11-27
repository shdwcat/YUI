/// @description renders YUI text
function YuiTextElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
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
				
		autotype: undefined, // simple option to enable typist.in()
		typist: undefined, // controls typewriter behavior
	};
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	props.text = yui_bind(props.text, resources, slot_values);
	props.typist = yui_bind(props.typist, resources, slot_values);
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	
	// look up the text style by name from the theme
	text_style = theme.text_styles[$ props.text_style];
		
	color = yui_bind(props.color ?? text_style.color, resources, slot_values);
	is_color_live = yui_is_live_binding(color);
	if !is_color_live {
		color = yui_resolve_color(color);
	}
	
	highlight_color = yui_resolve_color(yui_bind(props.highlight_color, resources, slot_values));
	
	font = props.font ?? text_style.font;
	if !is_string(font) {
		throw yui_error("Expecting font name");
	}
	
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
		};
	}
	
	static getBoundValues = function YuiTextElement_getBoundValues(data, prev) {
		if data_source != undefined {
			data = is_data_source_bound ? data_source.resolve(data) : data_source;
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
				
		var text = is_text_live && !is_array(props.text) ? props.text.resolve(data) : props.text;
		if text == undefined {
			return false;
		}
		
		var color = is_color_live
			? yui_resolve_color(self.color.resolve(data))
			: self.color;
		
		var opacity = is_opacity_live ? props.opacity.resolve(data) : props.opacity;
		var xoffset = is_xoffset_live ? props.xoffset.resolve(data) : props.xoffset;
		var yoffset = is_yoffset_live ? props.yoffset.resolve(data) : props.yoffset;
		
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
		
		// diff
		if prev
			&& text == prev.text
			&& opacity == prev.opacity
			&& xoffset == prev.xoffset
			&& yoffset == prev.yoffset
			&& color == prev.color
			&& typist == prev.typist
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			text: text,
			font: font,
			opacity: opacity,
			xoffset: xoffset,
			yoffset: yoffset,
			color: color,
			autotype: props.autotype,
			typist: typist,
		};
	}
}