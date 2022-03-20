/// @description renders a YUI Image
function YuiImageElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "image",			
		theme: "default",
		padding: 0,
		scale_mode: "slice", // stretch/tile/clip/none/etc
		center: false,
		
		sprite: undefined,
		ignore_sprite_origin: true, // default to draw as if origin is 0,0
		frame: 0,		
		angle: 0,
		blend_color: c_white,
	};
	
	props = yui_init_props(_props);
	yui_resolve_theme();
	props.padding = yui_resolve_padding(props.padding);
	
	props.sprite = yui_bind(props.sprite, resources, slot_values);
	props.frame = yui_bind(props.frame, resources, slot_values);
	props.angle = yui_bind(props.angle, resources, slot_values);
	props.opacity = yui_bind(props.opacity, resources, slot_values);
	props.blend_color = yui_bind(props.blend_color, resources, slot_values);
	
	is_bound = base_is_bound
		|| yui_is_live_binding(props.sprite)
		|| yui_is_live_binding(props.frame)
		|| yui_is_live_binding(props.angle)
		|| yui_is_live_binding(props.opacity)
		|| yui_is_live_binding(props.blend_color);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			padding: props.padding,
			size: size,
			alignment: alignment,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var sprite_name = yui_resolve_binding(props.sprite, data);
		
		// get the sprite asset from the name
		var sprite = yui_resolve_sprite_by_name(sprite_name);
		if sprite == -1 {
			sprite = undefined; // TODO pink placeholder warning sprite?
		}
		
		var frame = yui_resolve_binding(props.frame, data);
		var angle = yui_resolve_binding(props.angle, data);
		var blend_color = yui_resolve_color(yui_resolve_binding(props.blend_color, data));
		
		var opacity = yui_resolve_binding(props.opacity, data)
			?? draw_get_alpha();
		
		// diff
		if prev
			&& sprite == prev.sprite
			&& frame == prev.frame
			&& angle == prev.angle
			&& blend_color == prev.blend_color
			&& opacity == prev.opacity
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			sprite: sprite,
			frame: frame,
			angle: angle,
			blend_color: blend_color,
			opacity: opacity,
		};
	}
}