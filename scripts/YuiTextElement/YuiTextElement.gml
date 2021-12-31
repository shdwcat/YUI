/// @description renders YUI text
function YuiTextElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {		
		type: "text",		
		theme: "default",
		padding: 0,
		
		text: undefined,
		text_format: undefined,
		
		text_style: "body",
		font: undefined, // overrides text_style.font
		color: undefined, // overrides text_style.color
		highlight_color: undefined,
		
		// deprecated
		centered: false,
		
		autotype: undefined, // simple option to enable typist.in()
		typist: undefined, // controls typewriter behavior
	};
	
	props = init_props_old(_props);
	yui_resolve_theme();
	
	props.text = yui_bind(props.text, resources, slot_values);
	props.typist = yui_bind(props.typist, resources, slot_values);
	props.padding = yui_resolve_padding(props.padding);
	
	// look up the text style by name from the theme
	text_style = theme.text_styles[$ props.text_style];
	
	var font = props.font == undefined
		? text_style.font
		: props.font;
		
	color = props.color == undefined
		? text_style.color
		: yui_resolve_color(props.color);
	color = yui_bind(color, resources, slot_values);
	highlight_color = yui_resolve_color(props.highlight_color);
			
	if !is_string(font) font = font_get_name(font);
	else if !asset_get_index(font) {
		yui_warning ("could not find font with font name:", font, "- reverting to text_style.font");
		font = font_get_name(text_style.font);
	}
	self.font = font;
	
	is_bound = yui_is_live_binding(props.text)
		|| yui_is_live_binding(props.color)
		|| yui_is_live_binding(props.typist);
		
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
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
				
		var text = yui_resolve_binding(props.text, data);
		if text == "" || text == undefined {
			return false;
		}
		
		var color = yui_resolve_binding(self.color, data);
		
		// handle text array by joining the values		
		if is_array(text) {
			var joined_text = "";
			var i = 0; repeat array_length(text) {
				var text_item = text[i];
				
				// update binding expression to YuiBinding in place
				// TODO: do this on construction
				if yui_is_binding_expr(text_item) {
					var binding = yui_bind(text_item, resources, slot_values)
					props.text[i] = binding;
					text_item = binding;
				}				
				
				var item_text = yui_resolve_binding(text_item, data);
				joined_text += string(item_text);
				
				i++;
			}
			text = joined_text;
		}
			
		if props.text_format != undefined
		{
			text = string_replace(props.text_format, "{0}", text);
		}
		
		var typist = yui_resolve_binding(props.typist, data);
		
		// diff
		if prev
			&& text == prev.text
			&& color == prev.color
			&& typist == prev.typist
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			text: text,
			font: font,
			color: color,
			autotype: props.autotype,
			typist: typist,
		};
	}
}