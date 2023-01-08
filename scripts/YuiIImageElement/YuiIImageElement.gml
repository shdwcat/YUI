/// @description renders a YUI Image
function YuiImageElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "image",
		padding: 0,
		center: false,
		
		sprite: undefined,
		ignore_sprite_origin: true, // default to draw as if origin is 0,0
		frame: 0,		
		angle: 0,
		blend_color: c_white,
	};
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	props.padding = yui_resolve_padding(yui_bind(props.padding, resources, slot_values));
	
	props.sprite = yui_bind(props.sprite, resources, slot_values);
	is_sprite_live = yui_is_live_binding(props.sprite);
	if !is_sprite_live {
		sprite = yui_resolve_sprite_by_name(props.sprite);
		if sprite == -1 {
			sprite = undefined; // TODO pink placeholder warning sprite?
		}
	}
	
	props.frame = yui_bind(props.frame, resources, slot_values);
	props.angle = yui_bind(props.angle, resources, slot_values);
	
	props.blend_color = yui_bind(props.blend_color, resources, slot_values);
	is_blend_color_live = yui_is_live_binding(props.blend_color);	
	if !is_blend_color_live {
		props.blend_color = yui_resolve_color(props.blend_color);
	}
	
	is_bound = base_is_bound
		|| yui_is_live_binding(props.sprite)
		|| yui_is_live_binding(props.blend_color);
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			padding: props.padding,
			size: size,
			alignment: alignment,
		};
	}
	
	static getBoundValues = function YuiImageElement_getBoundValues(data, prev) {
		var sprite = is_sprite_live ? props.sprite.resolve(data) : self.sprite;
		
		if is_sprite_live {
			// get the sprite asset from the name
			sprite = yui_resolve_sprite_by_name(sprite);
			if sprite == -1 {
				sprite = undefined; // TODO pink placeholder warning sprite?
			}
		}

		if props.trace
			DEBUG_BREAK_YUI;
			
		var w = yui_resolve_binding(size.w, data);
		var h = yui_resolve_binding(size.h, data);
		
		// diff
		if prev
			&& sprite == prev.sprite
			&& w == prev.w
			&& h == prev.h
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			sprite: sprite,
			w: w,
			h: h,
		};
	}
}