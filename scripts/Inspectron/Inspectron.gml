// INSPECTRON - A fluent API for easily creating GameMaker debug views
// copyright @shdwcat 2024

// (these are restored at end of file)
// feather disable GM1056
// feather disable GM2017
// feather disable GM2043

if INSPECTRON_GESTURE_ENABLED
	InspectronSetGesture(INSPECTRON_GESTURE_MOUSE_BUTTON, INSPECTRON_GESTURE_MODIFIER);

/// @desc creates a debug overlay for any matching inspectable items found at the mouse coordinates
/// @param {Asset.GMObject,Id.Instance,Id.TileMapElement,Constant.All,Constant.Other,Array} game_kind
///		the GAME object or type of object to get at the mouse coordinates
///		(object index, instance, tile map element, all/other keyword, or an array of these values)
/// @param {Asset.GMObject,Id.Instance,Id.TileMapElement,Constant.All,Constant.Other,Array} gui_kind
///		the GUI object or type of object to get at the mouse's GUI coordinates
///		(object index, instance, tile map element, all/other keyword, or an array of these values)
/// @param {string} name the name for the debug view
/// @param {function} item_name_func function to customize how an instance is named in the debug view
function InspectronGo(game_kind = all, gui_kind = undefined, name = "Inspectron", item_name_func = undefined) {
	static overlay = new InspectronOverlay(name, item_name_func);	
	
	overlay.Reset()
		.Pick(INSPECTRON_MOUSE_X, INSPECTRON_MOUSE_Y, game_kind);
		
	if gui_kind != undefined
		overlay.Pick(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), gui_kind);
		
	overlay.Show();
}

/// @desc stops and hides the Inspectron overlay created by InspectronGo
///		(you probably don't ever need to call this)
function InspectronStop() {
	if InspectronGo.overlay != undefined {
		InspectronGo.overlay.Hide();
	}
}

function InspectronSetGesture(button, modifier = undefined) {
	static time_source = undefined;
	
	self.button = button;
	self.modifier = modifier;
	
	if time_source == undefined {
		time_source = time_source_create(
			time_source_global, 1, time_source_units_frames,
			function () {
				if mouse_check_button_released(button) and (modifier == undefined or keyboard_check(modifier)) {
						InspectronGo();
				}					
			},
			[],
			-1);
			
		time_source_start(time_source);
	}
}

// feather ignore GM1044
function InspectronClearGesture() {
	time_source_destroy(InspectronSetGesture.time_source);
	InspectronSetGesture.time_source = undefined;
}
// feather restore GM1044

/// @description Fluent API for easily creating GM debug overlays
/// @param {struct,id.instance} target
function Inspectron(target = undefined) {
	var had_target = target != undefined;
	
	target ??= self;
	
	// extend existing inspectron if there is one
	var existing = target[$ "inspectron"];
	
	var inspectron = new InspectronRenderer(target, existing);
	
	// if we were invoked without a target, set the inspectron on the target
	// (this makes it so that auto-extend works without hassling the user)
	if !had_target self.inspectron = inspectron;
	
	return inspectron;
}

/// @param {struct,id.instance} target
/// @param {struct.InspectronRenderer} extends
function InspectronRenderer(target, extends) constructor {
	self.target = target;
	self.extends = extends;
	
	if extends {
		// init top fields from our base so that they actually go to the top
		self.top_fields = extends.top_fields;
		extends.top_fields = [];
	}
	else {
		self.top_fields = [];
	}
	
	self.fields = [];
	
	/// @param {struct.InspectronField} field
	static __addField = function(field) {
		field.owner = self;
		array_push(fields, field);
		return self;
	}
	
	static Section = function(label) {
		return __addField(new InspectronSection(label));
	}
	
	static Header = function(header) {
		return __addField(new InspectronLabel($"[ {header} ]"));
	}
	
	static Button = function(label, on_click) {
		return __addField(new InspectronButton(label, on_click));
	}
	
	static Label = function(label) {
		return __addField(new InspectronLabel(label));
	}
	
	static Watch = function(field_name, label = undefined) {
		return __addField(new InspectronWatch(field_name, label));
	}
	
	static TextInput = function(field_name, label = undefined) {
		return __addField(new InspectronTextInput(field_name, label));
	}
	
	static Slider = function(field_name, minimum, maximum, label = undefined) {
		return __addField(new InspectronSlider(field_name, label, minimum, maximum));
	}
	
	static Bool = function(field_name, label = undefined) {
		return __addField(new InspectronBool(field_name, label));
	}
	
	static Checkbox = function(field_name, label = undefined) {
		return __addField(new InspectronCheckbox(field_name, label));
	}
	
	static Color = function(field_name, label = undefined) {
		return __addField(new InspectronColor(field_name, label));
	}
	
	static Sprite = function(field_name, label = undefined) {
		return __addField(new InspectronSprite(field_name, label));
	}
	
	static Rect = function(field_name, label = undefined) {
		return __addField(new InspectronRect(field_name, label));
	}
	
	static FieldsSuffix = function(field_filter, type, scope_name = undefined) {
		var test = function(name, filter) { return string_ends_with(name, filter) };
		return __addField(new InspectronFieldPicker(field_filter, test, type, scope_name));
	}
	
	static Picker = function(field_name, choices, label = undefined) {
		return __addField(new InspectronPicker(field_name, label, choices));
	}
	
	static LabeledPicker = function(field_name, choices, labels, label = undefined) {
		return __addField(new InspectronPicker(field_name, label, choices, labels));
	}
	
	static AssetPicker = function(field_name, asset_type, name_func, label = undefined) {
		return __addField(new InspectronAssetPicker(field_name, label, asset_type, name_func));
	}
		
	static FontPicker = function(field_name, label = undefined) {
		return __addField(new InspectronAssetPicker(field_name, label, asset_font, font_get_name));
	}
		
	static SpritePicker = function(field_name, label = undefined) {
		return __addField(new InspectronAssetPicker(field_name, label, asset_sprite, sprite_get_name));
	}
	
	// TODO convert to .FilterBy()
	static FilteredSpritePicker = function(field_name, filter_func, label = undefined) {
		return __addField(new InspectronAssetPicker(field_name, label, asset_sprite, sprite_get_name, filter_func));
	}
	
	static Include = function(field_name, label = undefined) {
		return __addField(new InspectronTargetReference(field_name, label));
	}
	
	//static OpenStruct = function(target) {
	//	if target == undefined throw "Can't .OpenStruct(target) if target is undefined!";
		
	//	var inner = Inspectron(target);
	//	inner.owner = self;
	//	__addField(inner);
	//	return inner;
	//}
	
	//static Close = function() {
	//	if owner == undefined throw "Can't call .Close() on a top level Inspectron!";
		
	//	return owner;
	//}
	
	/// @desc Ensures that the previous field will be rendered at the top of the inspector,
	///		even if the inspectron is inherited by a child object or derived constructor.
	///		(Useful for adding buttons/etc related to the base object/constructor.)
	static AtTop = function() {
		
		var last = array_pop(fields);
		if last == undefined throw "Cannot call .AtTop() before defining a field!";
		
		array_push(top_fields, last);
		
		return self;
	}
	
	/// @desc adds fields for many built-in instance variables
	static BuiltIn = function() {
		Section("Built-In");
		Watch(nameof(x));
		Watch(nameof(y));
		Watch(nameof(depth));
		Watch(nameof(vspeed));
		Watch(nameof(hspeed));
		Checkbox(nameof(visible));
		Checkbox(nameof(persistent));
		SpritePicker(nameof(sprite_index));
		Watch(nameof(sprite_xoffset));
		Watch(nameof(sprite_yoffset));
		Watch(nameof(sprite_width));
		Watch(nameof(sprite_height));
		Slider(nameof(image_alpha), 0, 1);
		Slider(nameof(image_index), 0, target.image_number);
		Color(nameof(image_blend));
	}
	
	/// @desc renders the inspectron to the current debug window
	/// @param {string} scope_name
	static render = function(scope_name = undefined, level = 0) {
		
		var all_fields = array_concat(top_fields, fields);
		
		var i = 0; repeat array_length(all_fields) {
			var field = all_fields[i++];
			field.render(target, scope_name, level);
		}
		
		if extends {
			extends.render(scope_name, level);
		}
	}
}

/// @desc base class for inspectron field items
function InspectronField(custom_label = undefined) constructor {
	self.custom_label = custom_label;
	
	self.owner = undefined;
		
	function __label(level) {
		var indent = string_repeat(INSPECTRON_INDENT, level);
		return $"{indent}{custom_label ?? field_name}";
	}

	/// @desc renders the inspectron field to the current debug window
	function render(scope, scope_name = undefined, level = 0) {
		dbg_text(label);
	}
}

function InspectronSection(name) : InspectronField() constructor {
	self.name = name;
	
	function render(scope, scope_name, level) {
		dbg_section(name);
	}
}

function InspectronButton(custom_label, on_click) : InspectronField() constructor {
	self.custom_label = custom_label;
	self.on_click = on_click;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		dbg_button(label, on_click);
	}
}

function InspectronLabel(custom_label) : InspectronField() constructor {
	self.custom_label = custom_label;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		dbg_text(label);
	}
}

function InspectronWatch(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		dbg_watch(ref_create(scope, field_name), label);
	}
}

function InspectronTextInput(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		dbg_text_input(ref_create(scope, field_name), label);
	}
}

function InspectronSlider(field_name, custom_label, minimum, maximum) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	self.minimum = minimum;
	self.maximum = maximum;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		dbg_slider(ref_create(scope, field_name), minimum, maximum, label);
	}
}

function InspectronBool(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level) + "?";
		dbg_watch(ref_create(scope, field_name), label);
	}
}

function InspectronCheckbox(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level) + "?";
		dbg_checkbox(ref_create(scope, field_name), label);
	}
}

function InspectronColor(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		var color = scope[$ field_name];
		
		// dbg_color will crash if color value is undefined
		if color == undefined {
			dbg_watch(ref_create(scope, field_name), label);
		}
		else {
			dbg_color(ref_create(scope, field_name), label);
		}
	}
}

function InspectronSprite(field_name, custom_label, index = 0) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	self.index = index;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		var sprite = scope[$ field_name];
		
		// dbg_sprite will crash if sprite value is undefined
		if sprite == undefined {
			dbg_watch(ref_create(scope, field_name), label);
		}
		else {
			dbg_sprite(ref_create(scope, field_name), index, label);
		}
	}
}

function InspectronRect(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		dbg_watch(ref_create(scope, field_name), label);
	}
}

function InspectronFieldPicker(filter, test, type, scope_override) : InspectronField() constructor {
	self.filter = filter;
	self.test = test;
	self.type = type;
	self.scope_override = scope_override;
	
	function render(scope, scope_name, level) {
		var target = scope_override != undefined and scope_override != ""
			? (scope[$ scope_override])
			: scope;
			
		var matched = false;
		
		var names = struct_get_names(target);
		var i = 0; repeat array_length(names) {
			var name = names[i++];
			if name != "inspectron" and test(name, filter) {
				
				if !matched {
					matched = true;
					if scope_override != undefined {
						var category = filter != ""
							? $"/{filter}s"
							: ""; 
						dbg_text($" {scope_override}{category}:");
					}
					else {
						dbg_text($" {filter}s:");
						scope_override = ""; // forces indent
					}
				}
				
				var field = new type(name);
				field.render(target, scope_override, level + 1);
			}
		}
	}
}

/// @param {string} field_name
/// @param {string} custom_label
/// @param {Constant.AssetType} asset_type
function InspectronTargetReference(field_name, custom_label) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		var target = scope[$ field_name];
		if target == undefined {
			dbg_watch(ref_create(scope, field_name), label);
		}
		else {
			var inspectron = target[$ "inspectron"];
			if inspectron == undefined throw "When using .Include(target), the target must have an inspectron defined!";
			
			dbg_text($" {label}:");
			inspectron.render(label, level + 1);
		}
	}
}

/// @param {string} field_name
/// @param {string} custom_label
/// @param {array} choices
/// @param {array<string>} labels
function InspectronPicker(field_name, custom_label, choices, labels = undefined) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	self.choices = choices;
	self.choice_labels = labels ?? choices;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		
		// feather disable GM1041
		dbg_drop_down(ref_create(scope, field_name), choices, choice_labels, label);
	}
}

/// @param {string} field_name
/// @param {string} custom_label
/// @param {Constant.AssetType} asset_type the asset type to choose
/// @param {Function} name_func function to get the name of the asset
/// @param {Function} filter_func asset => bool - function to filter the listed assets
function InspectronAssetPicker(field_name, custom_label, asset_type, name_func, filter_func = undefined) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	self.asset_type = asset_type;
	self.name_func = name_func;
	self.filter_func = filter_func;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		
		var assets = asset_get_ids(asset_type);
		
		// sort by name
		array_sort(assets, function(left, right) {
			var left_name = name_func(left);
			var right_name = name_func(right);
		    if left_name < right_name
		        return -1;
		    else if left_name > right_name
		        return 1;
		    else
		        return 0;
		});
		
		// now get the names as an array
		var names = array_map(assets, name_func);
		
		if filter_func != undefined {
			var i = 0; repeat array_length(assets) {
				var passed = filter_func(assets[i], names[i]);
				if !passed {
					array_delete(assets, i, 1);
					array_delete(names, i, 1);
				}
				else {
					i++;
				}
			}
		}
		
		// feather disable once GM1041
		dbg_drop_down(ref_create(scope, field_name), assets, names, label);
	}
}

/// @desc better dbg_drop_down()
/// @param {id.DbgRef} ref
/// @param {string} label
/// @param {Array<Any>} items
/// @param {Function} label_func
function InspectronArrayDropDown(ref, label, items, label_func) {
	
	var pairs = array_map(items, method({ label_func }, function(item, index) {
		return $"{label_func(item)}:{index}";
	}));
	var specifier = string_join_ext(",", pairs);
		
	dbg_drop_down(ref, specifier, label);
}

/// @param {string} name the name for the debug view
/// @param {function} item_name_func function that returns the display name for an inspectable item
// feather ignore GM1045
function InspectronOverlay(name = "Inspectron", item_name_func = undefined) constructor {
	self.name = name;
	self.item_name_func = item_name_func ?? function (instance) {
		return $"ID {real(instance.id)} - {object_get_name(instance.object_index)}";
	};
	
	self.debug_pointer = undefined;
	self.time_source = undefined;
	
	//self.frame = undefined;
	
	Reset();
	
	static Reset = function() {
		target = undefined;
		targets = [];
		pick_index = 0;
		
		self.current = {
			pick_index,
		}
		
		return self;
	}

	/// @desc finds instances of the provided 'kind' at the given coordinates 
	///		and adds them to the targets list for this InspectronOverlay
	/// @param {real} x the x position to check (in world coordinates, not GUI)
	/// @param {real} y the y position to check (in world coordinates, not GUI)
	/// @param {Asset.GMObject,Id.Instance,Id.TileMapElement,Constant.All,Constant.Other,Array} kind
	///		the object or type of object to get
	///		(object index, instance, tile map element, all/other keyword, or an array of these values)
	/// @returns {Array<Id.Instance>}
	static Pick = function(x, y, kind) {
	
		var list = ds_list_create();
		var count = instance_position_list(x, y, kind, list, false);
		
		var existing_count = array_length(targets);
		
		// push existing items to the end
		if existing_count > 0 {
			array_resize(targets, existing_count + count);
			array_copy(targets, count, targets, 0, existing_count);
		}

		// copy the list into the array in reverse order
		var i = 0; repeat count {
			targets[i] = list[| count - i - 1];
			i++;
		}
	
		ds_list_destroy(list);	

		return self;
	}
	
	static Show = function () {
		
		target = array_length(targets) > pick_index
			? targets[pick_index]
			: undefined;
			
		if target == undefined || !instance_exists(target) {
			Hide();
			return;
		}
		
		var inspectron = target[$ "inspectron"];
		if inspectron == undefined {
			if INSPECTRON_AUTO_INSPECT_ENABLED {
				with target {
					Inspectron().BuiltIn();
				}
			}
			else {
				return;
			}
		}
		
		// track current state for comparison in .Update()
		current = {
			pick_index,
		};
		
		// delete the old view
		if debug_pointer != undefined
			dbg_view_delete(debug_pointer);
		
		if time_source == undefined
			StartUpdateLoop();
		
		//if frame != undefined
		//	instance_destroy(frame);
			
		//var frame_x = target.x - target.sprite_xoffset;
		//var frame_y = target.y - target.sprite_yoffset;
		
		//var xscale = target.image_xscale;
		//var yscale = target.image_yscale;
		
		//frame = instance_create_depth(
		//	frame_x,
		//	frame_y,
		//	target.depth,
		//	InspectronDebugFrame,
		//	{
		//		w: target.sprite_width,
		//		h: target.sprite_height,
		//	});
		
		// position and show the debug view
		
		var window_rect = InspectronCalcOverlayRect(target);

		debug_pointer = dbg_view(
			$"{name} - {item_name_func(array_first(targets))}", true,
			window_rect.x, window_rect.y, window_rect.w, window_rect.h);
			
		dbg_section($"General");
					
		//dbg_text("debug window rect: " + window_rect.toString())
						
		InspectronArrayDropDown(
			ref_create(self, "pick_index"),
			$"Instances at {INSPECTRON_MOUSE_X}, {INSPECTRON_MOUSE_Y} (in depth order):",
			targets,
			item_name_func);

		// render whichever item was picked
		target.inspectron.render();
	}
	
	static Hide = function() {
		Reset();
		
		if time_source != undefined {
			time_source_destroy(time_source);
			time_source = undefined
		}
		
		if debug_pointer != undefined
			dbg_view_delete(debug_pointer);
	}
	
	static StartUpdateLoop = function() {
		
		// start a time source to call .Update() each frame
		time_source ??= time_source_create(
			time_source_global, 1, time_source_units_frames,
			function (overlay) {
				overlay.Update();
			},
			[ self ],
			-1);
			
		time_source_start(time_source);
	}
	
	/// @desc checks if any inspectron option values have changed so that the view can be updated
	static Update = function() {
		if target == undefined || !instance_exists(target) {
			Hide();
			return;
		}
				
		var needs_refresh =
			pick_index != current.pick_index;
			
		if needs_refresh Show();
	}
}
// feather restore GM1045

/// @desc calculates where to positon the Inspectron debug overlay
/// @param {Id.Instance} target the instance to position the overlay next to
/// @param {Id.Camera} camera the camera to use when determining GUI position
function InspectronCalcOverlayRect(target, camera = undefined) {
	
	/// @param {Real} x
	/// @param {Id.Camera,Real} camera
	static __worldToWindowX = function(x, camera = 0) {
		
		if view_enabled {
			var camera_x = camera_get_view_x(view_camera[camera]);
			var camera_w = camera_get_view_width(view_camera[camera]);
			var viewport_w = view_wport[camera];
			var window_w = window_get_width();

			// position relative to camera
			var xoffset = x - camera_x;

			// find the relation of the camera x to the camera size
			var camera_ratio_x = xoffset / camera_w;
			
			// multiply by the viewport size to get the x position in the view
			var x_in_viewport = camera_ratio_x * viewport_w;
		
			var view_scale_w = viewport_w / window_w;
			var x_in_window = x_in_viewport / view_scale_w;
		
			// account for the viewport's x
			x_in_window += view_get_xport(camera);

			return floor(x_in_window);
		}
		else {
			// when views are not enabled, the full room is drawn scaled to the window size
			var window_w = window_get_width();

			// find the relation of the room x to the room width
			var room_ratio_x = x / room_width;
			var x_in_window = room_ratio_x * window_w;

			return floor(x_in_window);
		}
	}
	
	/// @param {Real} y
	/// @param {Id.Camera,Real} camera
	static __worldToWindowY = function(y, camera = 0) {
		if view_enabled {
			var camera_y = camera_get_view_y(view_camera[camera]);
			var camera_h = camera_get_view_height(view_camera[camera]);
			var viewport_h = view_hport[camera];
			var window_h = window_get_height();

			// position relative to camera
			var yoffset = y - camera_y;

			// find the relation of the camera y to the camera size
			var camera_ratio_y = yoffset / camera_h;

			// multiple by the viewport size to get the x position in the view
			var y_in_viewport = camera_ratio_y * viewport_h;
		
			var view_scale_h = viewport_h / window_h;
			var y_in_window = y_in_viewport / view_scale_h;
		
			// account for the viewport's y
			y_in_window += view_get_yport(camera);
			
			return floor(y_in_window);
		}
		else {
			// when views are not enabled, the full room is drawn scaled to the window size
			var window_h = window_get_height();

			// find the relation of the room y to the room height
			var room_ratio_y = y / room_height;
			var y_in_window = room_ratio_y * window_h;

			return floor(y_in_window);
		}
	}
		
	var window_w = window_get_width();
	var window_h = window_get_height();
	
	// the default width and height may be too large for small
	// resolutions so constrain it to a reasonable size
	var max_w = min(INSPECTRON_WIDTH, window_w * .66);
	var max_h = min(INSPECTRON_HEIGHT, window_h * .66);
	var min_w = min(INSPECTRON_MIN_WIDTH, max_w * .75);
	var min_h = min(INSPECTRON_MIN_HEIGHT, max_h * .75);
	
	var max_x = window_w - max_w;
	var max_y = window_h - max_h;
	
	var target_x = target.x - target.sprite_xoffset;
	var target_y = target.y - target.sprite_yoffset;
	var target_left = __worldToWindowX(target_x, camera);
	var target_top = __worldToWindowY(target_y, camera);
			
	var target_w = 0;
	var target_h = 0;
	if target.sprite_index >= 0 {
		target_w = target.sprite_width;
		target_h = target.sprite_height;
	}
	else {
		show_debug_message("Warning: Inspectron was unable to determine the target's size because it has no sprite");
	}
			
	var target_right = __worldToWindowX(target_x + target_w, camera);
	var target_bottom = __worldToWindowY(target_y + target_h, camera);
	
	// remember our original desired size in case we need to reset after repositioning
	var original_desired_w = min(INSPECTRON_WIDTH, max_w);
	var original_desired_h = min(INSPECTRON_HEIGHT, max_h);
			
	var position = "right";
	var desired_x = target_right + 5;
	var desired_y = target_top;
	var desired_w = min(original_desired_w, max_w);
	var desired_h = min(original_desired_h, max_h);
			
	var free_w = window_w - desired_x;

	if free_w < desired_w {
		if free_w > min_w {
			desired_w = free_w;
		}
		else if target_left + min_h < window_w {
			// reposition down
			//show_debug_message("repositioning down (from width)");
			position = "down";
			desired_x = target_left;
			desired_y = target_bottom + 5;
		}
		else {
			// reposition left
			//show_debug_message("repositioning left (from width)");
			position = "left";
			desired_x = target_left - desired_w;
			desired_y = target_top;
		}
	}
			
	var free_h = window_h - desired_y;
	if free_h < desired_h {
		if free_h > min_h {
			// squeeze if we can
			desired_h = free_h;
		}
		else if position == "right" {
			// if we had room to the right, just move the view up on screen
			desired_h = min_h;
			desired_y = window_h - desired_h;
		}
		else {
			// reposition left
			//show_debug_message("repositioning left (from height)");
			position = "left";
			desired_x = target_left - original_desired_w;
			desired_y = target_top;
					
			// check height again
			free_h = window_h - desired_y;
			if free_h < original_desired_h {
				if free_h > min_h {
					desired_h = free_h;
				}
				else {
					// just move the view up on screen
					desired_h = min_h;
					desired_y = window_h - desired_h;
				}
			}
		}
	}
			
	// if off screen left or above, reposition bottom right
	if desired_x < 0 || desired_y < 0 {
		//show_debug_message("positioning bottom right as last resort");
		position = "bottom_right";
		desired_x = max_x;
		desired_y = max_y;
		desired_w = max_w;
		desired_h = max_h;
	}
	
	//show_debug_message($"Target: x: {target.x}, y: {target.y}");
	//show_debug_message($"Window: w: {window_w}, h: {window_h}");
	//show_debug_message($"Debug View: x: {desired_x}, y: {desired_y}, w: {desired_w}, h: {desired_h}");
	
	return {
		x: desired_x,
		y: desired_y,
		w: desired_w,
		h: desired_h,
	};
}

// feather restore GM1056
// feather restore GM2017
// feather restore GM2043