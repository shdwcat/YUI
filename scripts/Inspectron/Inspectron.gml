// INSPECTRON - A Fluent API for easily creating GM debug overlays
// copyright @shdwcat 2023 

#macro INSPECTRON_INDENT "    "

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
		
	static FontPicker = function(field_name, label = undefined) {
		return __addField(new InspectronAssetPicker(field_name, label, asset_font));
	}
	
	static Include = function(field_name, label = undefined) {
		return __addField(new InspectronTargetReference(field_name, label));
	}
	
	/// @desc renders the inspectron to the current debug window
	/// @param {string} scope_name
	static render = function(scope_name = undefined, level = 0) {
		var i = 0; repeat array_length(fields) {
			var field = fields[i++];
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
/// @param {Constant.AssetType} asset_type
function InspectronAssetPicker(field_name, custom_label, asset_type) : InspectronField(custom_label) constructor {
	self.field_name = field_name;
	self.asset_type = asset_type;
	
	function render(scope, scope_name, level) {
		var label = __label(level);
		
		var assets = asset_get_ids(asset_type);
		var pairs = array_map(assets, function(asset) {
			var name = font_get_name(asset);
			var index = real(asset);
			return $"{name}:{index}";
		});
		var specifier = string_join_ext(",", pairs);
		
		dbg_drop_down(ref_create(scope, field_name), specifier, label);
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

// feather restore GM1056