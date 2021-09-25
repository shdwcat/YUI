/// @description renders a YUI Button
function YuiButtonRenderer(_props, _resources) : YuiBaseRenderer(_props, _resources) constructor {
	static default_props = {		
		type: "button",
		theme: "default",
		
		bg_sprite: noone,
		bg_color: noone,
		border_color: noone,
		border_thickness: 1,
		
		padding: undefined, // default to theme value
		
		content: noone,
		fit_to_content: true, // can be true/false/width/height
		
		popup: noone, // setting popup will show a popup in an overlay
		
		mouseover_color: $55555555,
		mousedown_color: $99999999,
		
		enabled: true, // can be bound
		on_click: noone,
		click_button: mb_left,
	}
	
	props = init_props_old(_props);
	yui_resolve_theme();
	props.enabled = yui_bind(props.enabled, _resources);
	
	var use_theme_bg = props.bg_sprite == noone && props.bg_color == noone;
	if use_theme_bg {
		bg_sprite = theme.button.bg_sprite;
	}
	else if props.bg_sprite != noone {
		bg_sprite = yui_resolve_sprite_by_name(props.bg_sprite, _resources);
	}
	else {
		bg_sprite = noone;
	}
		
	// convert props.bg_color string to an actual color
	bg_color = noone;
	if props.bg_color != noone {
		bg_color = yui_resolve_color(props.bg_color);
	}
	border_color = noone;
	if props.border_color != noone {
		border_color = yui_resolve_color(props.border_color);
	}
	
	content_renderer = yui_resolve_renderer(props.content, _resources);
	
	// set up popup mode
	if props.popup != noone {
		
		// TODO: create a YuiPopupRenderer and pass props.popup
		// in order to handle click events so that they don't dismiss the popup
		// e.g. if clicking on a popup that's just text or whatever and not a button
		
		props.popup.type = "popup"
		popup_renderer = yui_resolve_renderer(props.popup, _resources);		
		var toggle_popup = function() {
			return function(prev_state, next_state) {
				next_state.popup_visible = !prev_state.popup_visible;
			}
		};
		props.on_click = {
			handler: toggle_popup,
			parameters: [],
			target: false,
		};
		var hide_popup = function() {
			return function(prev_state, next_state) {				
				next_state.popup_visible = false;
			}
		};
		props.events.on_click_outside = {
			handler: hide_popup,
			parameters: [],
			target: false,
		};
	}
	
	// ===== functions =====
	
	static getInitialAnimationState = function() {
		return { popup_visible: false };
	}
	
	static update = function(ro_context, data, draw_rect, item_index) {
		
		if data_source != undefined {
			if instanceof(data_source) == "YuiBinding" || instanceof(data_source) == "YuiMultiBinding" {
				data = ro_context.resolveBinding(data_source, data);
			}
			else {
				data = data_source;
			}
		}
		
		var is_visible = ro_context.resolveBinding(props.visible, data);
		if !is_visible return false;
		
		// TODO fix theme implementation
		var padding = props.padding == undefined ? theme.button.padding : props.padding;
												
		// get the padded rect for the inner content
		var padding_info = yui_apply_padding(draw_rect, padding);
		var padded_rect = padding_info.padded_rect;
		
		if props.trace {
			var trace = true;
		}
		
		content_result = undefined;
		if props.content != noone {
			var content_size;
			content_result = content_renderer.update(ro_context, data, padded_rect, item_index);
			if !content_result return false;
			
			if props.fit_to_content != false {
				if padded_rect.w == 0 || padded_rect.h == 0 {
					yui_log("invalid button content");
					return draw_rect;
				}
				
				switch props.fit_to_content {
					case true:
						content_size = {
							w: content_result.w,
							h: content_result.h,
						};
						break;
					case "width":
						content_size = {
							w: content_result.w,
							h: padded_rect.h,
						};
						break;
					case "height":
						content_size = {
							w: padded_rect.w,
							h: content_result.h,
						};
						break;
				}
			}
			else {
				content_size = {
					w: content_result.w,
					h: content_result.h,
				};
			}
		}
		else if bg_sprite != noone {
			content_size = {
				w: sprite_get_width(bg_sprite),
				h: sprite_get_height(bg_sprite),
			};
		}
		else {
			throw "button needs content or bg_sprite!";
		}

		// get the actual size by reversing the padding on the rendered size
		var size = {
			w: content_size.w,
			h: content_size.h,
		};
		if props.content != noone && padding != undefined {			
			size.w += padding_info.padding_size.w;
			size.h += padding_info.padding_size.h;
		}
				
		var enabled = ro_context.resolveBinding(props.enabled, data);
		
		var renderer = self;
		var result = yui_instruction({
			x: draw_rect.x,
			y: draw_rect.y,
			w: size.w,
			h: size.h,
			enabled: enabled,
			
			renderer: renderer,
			content: content_result,
			trace: props.trace,
			
			draw: function() {
				
				if !enabled {
					var alpha = draw_get_alpha();
					draw_set_alpha(.5);
					
				}
				
				renderer.drawBackground(x, y, w, h);
				
				if content != undefined {
					content.draw();
				}
				
				if !enabled draw_set_alpha(alpha);
				
				yui_draw_trace_rect(trace, self, c_purple);
			}
		})
		
		// create click/mouseover hotspot
		if enabled && props.on_click != noone {
			ro_context.addHotspot(result, self, onHotspot, props.trace, data);
		}
		
		if props.popup != noone {
			var state_key = getStateKey(ro_context, data);
			var state = ro_context.getAnimationState(state_key);
			if state != undefined && state.popup_visible {
				result.overlay = yui_render_overlay(
					ro_context,
					result,
					props.popup.placement,
					popup_renderer,
					data,
					item_index,
					state_key);
			}
		}
		else {
			result.tooltip = yui_render_tooltip_if_any(ro_context, result, props, data, item_index);
		}
		
		return result;
	}
	
	static onHotspot = function(hotspot, cursor_state, cursor_event) {
		var draw_rect = hotspot.rect;
		
		var cursor_press = mouse_check_button(props.click_button);
		var cursor_release = mouse_check_button_released(props.click_button);
		
		// NOTE: we still want to run the hover and cursor_down_outside code even if the 
		// click has already been consumed
		var mousedown = !cursor_event.cursor_press_consumed && cursor_press;
		var clicked = !cursor_event.cursor_click_consumed && cursor_release;
		
		// NOTE: currently no verification that the press was on the same button as the release!
		// can we handle this in YuiCursorManager by tracking the cursor_pos when the mouse is down
		// and passing it along in cursor_state as prev_mouse_down_state?
				
		if props.trace {
			if (mousedown || clicked) {
				yui_log("press/click - cursor:", cursor_state);
			}
		};
			
		if cursor_state.hover {
			cursor_event.hover_consumed = true;
			
			if props.tooltip != noone onTooltip(hotspot, cursor_state, cursor_event);
			
			var overlay_color = noone;
			if mousedown
				overlay_color = props.mousedown_color;
			else if !clicked
				overlay_color = props.mouseover_color;
			
			if overlay_color {			
				hotspot.result = yui_instruction({
					x: draw_rect.x,
					y: draw_rect.y,
					w: draw_rect.w,
					h: draw_rect.h,
					
					renderer: hotspot.renderer,
					overlay_color: overlay_color,
					
					draw: function() {
						renderer.drawHighlight(self, overlay_color);
					},
				});
				
			}
		}
		
		if clicked && cursor_state.hover {
			// call the click handler
			cursor_event.consumeClick(hotspot.ro_context.overlay_id);
			yui_log("button", props.id, "consumed release and click for layer", hotspot.ro_context.overlay_id);
			var event = props.on_click;
			yui_call_event_handler(event, self, hotspot.ro_context, hotspot.data);
		}
		else if props.events.on_click_outside && cursor_release && !cursor_state.hover {
			var clicked_outside = true;
			
			// check if this button is a parent of the layer that consumed the click
			// NOTE: child layers handle events before parents, so order is guaranteed
			var click_overlay_id = cursor_event.click_overlay_id;
			if click_overlay_id != undefined {
				var my_overlay_id = hotspot.ro_context.overlay_id;
				if my_overlay_id == undefined my_overlay_id = getStateKey(hotspot.ro_context, hotspot.data);				
				
				// FUTURE: could be faster for layers to track parents directly and walk the parents, but we're not hard on perf here yet
				if string_pos(my_overlay_id, click_overlay_id) == 1 {
					clicked_outside = false;
				}
			}
			
			if clicked_outside {
				// call the click_outside handler
				// NOTE: no event is consumed here!
				// NOTE: does it matter which button? probably not...
				var event = props.events.on_click_outside;
				yui_call_event_handler(event, self, hotspot.ro_context, hotspot.data);
				//yui_log("button clicked outside - my id:", props.id, " - click layer:",click_overlay_id);
			}
		}
	}
	
	static drawBackground = function(x, y, w, h) {
		// draw the bg sprite or bg color
		if bg_sprite {
			draw_sprite_stretched(bg_sprite, 0, x, y, w, h);
		}
		else if bg_color != noone {			
			draw_rectangle_color(
				x, y, x + w - 1, y + h - 1,
				bg_color, bg_color, bg_color, bg_color, false);
		}
		
		// draw border
		if border_color != noone {
			if props.border_thickness > 0 {				
				yui_draw_rect_outline(
					x, y, w, h,
					props.border_thickness, border_color);
			}
		}
	}
	
	static drawHighlight = function(draw_rect, overlay_color) {
		if bg_sprite {
			gpu_set_blendmode(bm_add);
			draw_sprite_stretched_ext(
				bg_sprite, 0,
				draw_rect.x, draw_rect.y, draw_rect.w, draw_rect.h,
				overlay_color, bm_add);
			gpu_set_blendmode(bm_normal);
		}
		else if bg_color {
			var bm = gpu_get_blendmode();
			gpu_set_blendmode(bm_add);
					
			var alpha = color_get_alpha(overlay_color)
			var old_alpha = draw_get_alpha();
			draw_set_alpha(alpha);
					
			draw_rectangle_color(
				draw_rect.x, draw_rect.y, draw_rect.x + draw_rect.w - 1, draw_rect.y + draw_rect.h - 1,
				bg_color, bg_color, bg_color, bg_color, false);
					
			draw_set_alpha(old_alpha);
			gpu_set_blendmode(bm);
		}
	}
}