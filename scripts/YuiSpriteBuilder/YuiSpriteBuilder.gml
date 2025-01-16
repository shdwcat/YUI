/// @description here
function YuiSpriteBuilder(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "sprite",
		
		// the YUI content to draw to the sprite
		content: undefined,
	};
	
	props = yui_apply_props(_props, _props[$ "template_def"]);
	
	content_element = yui_resolve_element(props.content, _resources, _slot_values);
	
	makeRenderItem = function(data) {
		var render_object = yui_resolve_render_item(content_element.props.type, content_element.props);
		if render_object == undefined {
			throw yui_error("unknown element type:", content_element.props.type);
		}
		
		var render_item = instance_create_depth(0, 0, 0, render_object, {
			data_context: data,
			yui_element: content_element,
			parent: undefined,
			document: undefined,
			
			// required because of gml silliness
			focus_scope: undefined,
			item_index: undefined,
		});
	
		return render_item;
	}
	
	buildSprite = function(data, width = undefined, height = undefined, origin_x = 0, origin_y = 0) {
		
		#region validation
		if width == undefined {
			if is_numeric(content_element.size.w)
				width = content_element.size.w
			else
				throw yui_error($"YuiSpriteBuilder: width not specified, and content_element width '{content_element.size.w}' is not numeric");
		}
		else if !is_numeric(width) {
				throw yui_error($"YuiSpriteBuilder:  width '{width}' is not numeric");
		}
		
		if height == undefined {
			if is_numeric(content_element.size.h)
				height = content_element.size.h
			else
				throw yui_error($"YuiSpriteBuilder: height not specified, and content_element height '{content_element.size.h}' is not numeric");
		}
		else if !is_numeric(height) {
				throw yui_error($"YuiSpriteBuilder:  height '{height}' is not numeric");
		}
		#endregion
		
		var render_item = makeRenderItem(data);
		
		// init all the items in the render tree
		render_item.doTraverse(function () {
			visible = true;
			initLayout();
			bind_values();
			build();
			enabled = true;
			opacity = 1;
		});
		
		// arrange the tree
		var draw_size = {
			x: 0,
			y: 0,
			w: width,
			h: height,
		};
		render_item.arrange(draw_size);
		
		// setup surface
		var sprite_surface = surface_create(width, height);
		
		// store and reset the previous render target		
		var old_surface = surface_get_target();
		if old_surface surface_reset_target();
		
		// set and clear the new render target
		surface_set_target(sprite_surface);
		draw_clear_alpha(c_black, 0);
		
		global.yui_sprite_builder_index = 0;
		global.sprite_builder_surface = sprite_surface;
		
		// draw the render item
		render_item.doTraverse(function() {
			event_perform(ev_draw, ev_draw_pre);
			event_perform(ev_draw, ev_gui);
			
			// Performing draw events messes up the active surface target such that further
			// draw commands won't work, but surface_get_target will still report as active.
			// However, setting the surface again fixes the problem
			surface_reset_target();
			surface_set_target(global.sprite_builder_surface);
		});
	
		// destroy the render tree now that we're done with it
		var tree_items = [];
		render_item.doTraverse(function(items) { array_push(items, id); }, tree_items);
		array_foreach(tree_items, instance_destroy);
		
		// reset the render target
		surface_reset_target();
		if old_surface surface_set_target(old_surface);	
		
		// make the sprite
		var sprite = sprite_create_from_surface(sprite_surface, 0, 0, width, height, false, false, origin_x, origin_y);
		
		// GM <2024.4 doesn't return a ref, so convert index to ref manually
		if is_numeric(sprite) {
			var name = sprite_get_name(sprite);
			sprite = asset_get_index(name);
		}
		
		// free the surface
		surface_free(sprite_surface);
		
		return sprite;
	}
}

function YuiSpriteCache() constructor {
	cache = {};
	destroyed = false;
	
	get = function(cache_id) {
		if cache_id == undefined 
			throw yui_error("YuiSpriteCache.getOrBuild cache_id parameter was undefined");

		// returns undefined if missing
		return cache[$ cache_id];
	}
	
	set = function(cache_id, value) {
		cache[$ cache_id] = value;
	}
	
	destroy = function() {
		struct_foreach(cache, function (k, v) {
			sprite_delete(v);
			cache[$ k] = undefined;
		});
		cache = undefined;
		destroyed = true;
	}
}