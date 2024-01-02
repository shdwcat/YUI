// INSPECTRON - A Fluent API for easily creating GM debug overlays
// copyright @shdwcat 2023 

// === Configuration - edit these if you want! ===

// default size of the debug overlay
#macro INSPECTRON_WIDTH 700
#macro INSPECTRON_HEIGHT 550

// minimum size of the overlay if space is restricted
#macro INSPECTRON_MIN_WIDTH 500
#macro INSPECTRON_MIN_HEIGHT 300

// how much to indent nested values (e.g. structs or linked instances)
#macro INSPECTRON_INDENT "    "





// === Inspectron code below! ===

// (these are restored at end of file)
// feather disable GM1056

/// @description Fluent API for easily creating GM debug overlays
/// @param {struct,id.instance} target
// feather disable once GM2017
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
	
	/// @desc Ensures that the previous field will be rendered at the top of the inspector,
	///		even if the inspectron is inherited by a child object or derived constructor.
	///		(Useful for adding buttons/etc related to the base object/constructor.)
	static AtTop = function() {
		
		var last = array_pop(fields);
		if last == undefined throw "Cannot call .AtTop() before defining a field!";
		
		array_push(top_fields, last);
		
		return self;
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
		
		// feather disable once GM1041
		dbg_drop_down(ref_create(scope, field_name), choices, choice_labels, label);
	}
}

/// @param {string} field_name
/// @param {string} custom_label
/// @param {Constant.AssetType} asset_type the asset type to choose
/// @param {Function} name_func function to get the name of the asset
/// @param {Function} filter_func asset => bool - function to filter the listed assets
function InspectronAssetPicker(field_name, custom_label, asset_type, name_func, filter_func) : InspectronField(custom_label) constructor {
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
// feather ignore once GM2017
function InspectronArrayDropDown(ref, label, items, label_func) {
	
	var pairs = array_map(items, method({ label_func }, function(item, index) {
		return $"{label_func(item)}:{index}";
	}));
	var specifier = string_join_ext(",", pairs);
		
	dbg_drop_down(ref, specifier, label);
}

/// @desc calculates where to positon the Inspectron debug overlay
/// @param {id.Instance} target the instance to position the overlay next to
// feather ignore once GM2017
function InspectronCalcOverlayRect(target) {
		
	var window_w = window_get_width();
	var window_h = window_get_height();
	var max_x = window_w - INSPECTRON_WIDTH;
	var max_y = window_h - INSPECTRON_HEIGHT;
			
	var target_left = target.x;			
	var target_top = target.y;
			
	var target_w = 0;
	var target_h = 0;
	if target.sprite_index >= 0 {
		target_w = sprite_get_width(target.sprite_index) * target.image_xscale;
		target_h = sprite_get_height(target.sprite_index) * target.image_yscale;
	}
	else {
		show_debug_message("Warning: Inspectron was unable to determine the target's size because it has no sprite");
	}
			
	var target_right = target_left + target_w;
	var target_bottom = target_top + target_h;
			
	var position = "right";
	var desired_x = target_right + 5;
	var desired_y = target_top;
	var desired_w = INSPECTRON_WIDTH;
	var desired_h = INSPECTRON_HEIGHT;
			
	var free_w = window_w - desired_x;
			
	if free_w < desired_w {
		if free_w > INSPECTRON_MIN_WIDTH {
			desired_w = free_w;
		}
		else if target_left + INSPECTRON_MIN_HEIGHT < window_w {
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
			desired_x = target_left - INSPECTRON_WIDTH;
			desired_y = target_top;
		}
	}
			
	var free_h = window_h - desired_y;
	if free_h < INSPECTRON_HEIGHT {
		if free_h > INSPECTRON_MIN_HEIGHT {
			// squeeze if we can
			desired_h = free_h;
		}
		else if position == "right" {
			// if we had room to the right, just move the view up on screen
			desired_h = INSPECTRON_MIN_HEIGHT;
			desired_y = window_h - desired_h;
		}
		else {
			// reposition left
			//show_debug_message("repositioning left (from height)");
			position = "left";
			desired_x = target_left - INSPECTRON_WIDTH;
			desired_y = target_top;
					
			// check height again
			free_h = window_h - desired_y;
			if free_h < INSPECTRON_HEIGHT {
				if free_h > INSPECTRON_MIN_HEIGHT {
					desired_h = free_h;
				}
				else {
					// just move the view up on screen
					desired_h = INSPECTRON_MIN_HEIGHT;
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
		desired_w = INSPECTRON_WIDTH;
		desired_h = INSPECTRON_HEIGHT;
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