/// @description renders a YUI Image
function YuiImageElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "image",
		padding: 0,
		
		// reference to a sprite asset
		sprite: undefined,
		// OR a sprite builder to build the sprite from YUI content
		sprite_builder: undefined,
		sprite_cache: undefined, // the YuiSpriteCache to track the built sprite(s)
		sprite_cache_id: undefined, // string key that determines whether a sprite needs to be built
		
		frame: undefined,
		angle: 0,
		mirror: undefined,
		blend_color: c_white,
	};
	
	props = yui_apply_element_props(_props);
	
	baseInit(props);
	
	sprite = yui_bind(props.sprite, _resources, _slot_values);
	is_sprite_live = yui_is_live_binding(sprite);
	if !is_sprite_live {
		validateSprite(sprite);
	}
	
	sprite_builder = yui_resolve_element(props.sprite_builder, _resources, _slot_values);
	is_sprite_cache_live = false;
	is_sprite_cache_id_live = false;
	if sprite_builder {
		sprite_cache = yui_bind(props.sprite_cache, _resources, _slot_values);
		is_sprite_cache_live = yui_is_live_binding(sprite_cache);
		sprite_cache_id = yui_bind(props.sprite_cache_id, _resources, _slot_values);
		is_sprite_cache_id_live = yui_is_live_binding(sprite_cache_id);
	}
	
	frame = yui_bind(props.frame, _resources, _slot_values);
	angle = yui_bind(props.angle, _resources, _slot_values);
	mirror = yui_bind(props.mirror, _resources, _slot_values);
	
	blend_color = yui_bind(props.blend_color, _resources, _slot_values);
	is_blend_color_live = yui_is_live_binding(blend_color);	
	if !is_blend_color_live {
		blend_color = yui_resolve_color(blend_color);
	}
	
	is_bound = base_is_bound
		|| is_sprite_live
		|| is_sprite_cache_live
		|| is_sprite_cache_id_live;
	
	// ===== functions =====
	
	static getLayoutProps = function() {
		return {
			padding,
			size,
			alignment,
		};
	}
	
	static validateSprite = function(sprite) {
		var is_valid_sprite = sprite == undefined
			|| sprite == -1
			|| is_handle(sprite) && sprite_exists(sprite);
		if !is_valid_sprite {
			throw yui_error($"image.sprite must be a sprite asset (got: ({typeof(sprite)}) {sprite})");
		}
	}
	
	// feather ignore once GM2017
	static getBoundValues = function YuiImageElement_getBoundValues(data, prev, item) {

		//if props.trace
		//	yui_break();
			
		if sprite_builder {
			var cache_id = is_sprite_cache_id_live ? sprite_cache_id.resolve(data) : sprite_cache_id;
			
			var cache = is_sprite_cache_live ? sprite_cache.resolve(data) : sprite_cache;
			if !is_instanceof(cache, YuiSpriteCache)
				throw yui_error("image.sprite_cache must resolve to a YuiSpriteCache when using sprite_builder");
				
			var sprite = cache.get(cache_id);
			
			var sprite_changed = sprite == undefined;
			if sprite_changed {
				// build the new sprite and store it in the cache
				sprite = sprite_builder.buildSprite(data);
				cache.set(cache_id, sprite);
			}
		}
		else {
			var sprite_changed = item.sprite_value.update(data);
			var sprite = item.sprite_value.value;
			if sprite_changed {
				validateSprite(sprite);
			}
			
			var cache_id = undefined;
		}
			
		var w = yui_resolve_binding(size.w, data);
		var h = yui_resolve_binding(size.h, data);
		var mirror = yui_resolve_binding(self.mirror, data);
		var mirror_x = mirror == true || mirror == "x";
		var mirror_y = mirror == true || mirror == "y";
		
		// diff
		if prev
			&& !sprite_changed
			&& w == prev.w
			&& h == prev.h
			&& mirror_x == prev.mirror_x
			&& mirror_y == prev.mirror_y
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			data_source: data,
			sprite,
			sprite_cache_id: cache_id,
			w,
			h,
			mirror_x,
			mirror_y,
		};
	}
}