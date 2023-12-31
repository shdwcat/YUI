// INSPECTRON - A Fluent API for easily creating GM debug overlays
// copyright @shdwcat 2023 


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
	
	// TODO: support custom label on everything
	
	static Header = function(header) {
		array_push(fields, new InspectronLabel($"[ {header} ]"));
		return self;
	}
	
	static Label = function(label) {
		array_push(fields, new InspectronLabel(label));
		return self;
	}
	
	static Watch = function(field_name) {
		array_push(fields, new InspectronWatch(field_name));
		return self;
	}
	
	static TextInput = function(field_name, label = undefined) {
		array_push(fields, new InspectronTextInput(field_name, label));
		return self;
	}
	
	static Bool = function(field_name) {
		array_push(fields, new InspectronBool(field_name));
		return self;
	}
	
	static Checkbox = function(field_name) {
		array_push(fields, new InspectronCheckbox(field_name));
		return self;
	}
	
	static Color = function(field_name) {
		array_push(fields, new InspectronColor(field_name));
		return self;
	}
	
	static Sprite = function(field_name) {
		array_push(fields, new InspectronSprite(field_name));
		return self;
	}
	
	static Rect = function(field_name) {
		array_push(fields, new InspectronRect(field_name));
		return self;
	}
	
	static FieldsSuffix = function(field_filter, type, scope_name = undefined) {
		var test = function(name, filter) { return string_ends_with(name, filter) };
		array_push(fields, new InspectronFieldPicker(field_filter, test, type, scope_name));
		return self;
	}
	
	/// @desc renders the inspectron to the current debug window
	static render = function() {
		var i = 0; repeat array_length(fields) {
			var field = fields[i++];
			field.render(target);
		}
		
		if extends {
			extends.render();
		}
	}
}

/// @desc base class for inspectron field items
function InspectronField() constructor {

	/// @desc renders the inspectron field to the current debug window
	function render(scope, scope_name = undefined) {
		dbg_text(label);
	}
}

function InspectronLabel(label) : InspectronField() constructor {
	self.label = label;
	
	function render(scope, scope_name) {
		dbg_text(label);
	}
}

function InspectronWatch(field_name) : InspectronField() constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, field_name);
		dbg_watch(ref_create(scope, field_name), label);
	}
}

function InspectronTextInput(field_name, custom_label) : InspectronField() constructor {
	self.field_name = field_name;
	self.custom_label = custom_label;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, custom_label ?? field_name);
		dbg_text_input(ref_create(scope, field_name), label);
	}
}

function InspectronBool(field_name) : InspectronField() constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, field_name) + "?";
		dbg_watch(ref_create(scope, field_name), label);
	}
}

function InspectronCheckbox(field_name) : InspectronField() constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, field_name) + "?";
		dbg_checkbox(ref_create(scope, field_name), label);
	}
}

function InspectronColor(field_name) : InspectronField() constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, field_name);
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

function InspectronSprite(field_name, index = 0) : InspectronField() constructor {
	self.field_name = field_name;
	self.index = index;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, field_name);
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

function InspectronRect(field_name) : InspectronField() constructor {
	self.field_name = field_name;
	
	function render(scope, scope_name) {
		var label = __inspectronLabel(scope_name, field_name);
		dbg_watch(ref_create(scope, field_name), label);
	}
}

function InspectronFieldPicker(filter, test, type, scope_override) constructor {
	self.filter = filter;
	self.test = test;
	self.type = type;
	self.scope_override = scope_override;
	
	function render(scope, scope_name) {
		var target = scope_override != undefined and scope_override != ""
			? (scope[$ scope_override])
			: scope;
			
		var matched = false;
		
		var names = struct_get_names(target);
		var i = 0; repeat array_length(names) {
			var name = names[i++];
			if test(name, filter) {
				
				if !matched {
					matched = true;
					if scope_override != undefined {
						dbg_text($" {scope_override}/{filter}s:");
					}
					else {
						dbg_text($" {filter}s:");
						scope_override = ""; // forces indent
					}
				}
				
				var field = new type(name);
				field.render(target, scope_override);
			}
		}
	}
}

// internal util

// feather disable once GM2017
function __inspectronLabel(scope_name, field_name) {
	return scope_name != undefined
		? $"    {field_name}"
		: field_name
}