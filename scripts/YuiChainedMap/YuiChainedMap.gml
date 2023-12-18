/// @description implements a map with chainable parents
function YuiChainedMap(parent = undefined, values = undefined) constructor {
	
	if parent && instanceof(parent) != "YuiChainedMap"
		throw yui_error("YuiChainedMap parent must be another YuiChainedMap");
	
	self.parent = parent;
	self.map = values;
	
	static get = function(key, trycatch = true) {
		// NOTE: we need to check if the variable exists because
		// undefined is a valid value to have in the map
		if map && variable_struct_exists(map, key) {
			return map[$ key];
		}
		else if parent {
			if trycatch {
				try {
					return parent.get(key, /*trycatch*/ false);
				}
				catch (error) {
					throw error;
				}
			}
			else {
				return parent.get(key);
			}
		}
		else {
			throw yui_error("slot key was not defined:", key);
		}	
	}
	
	static set = function(key, value) {
		self.map ??= {};
		map[$ key] = value;
	}
	
	static extendWith = function(overrides) {
		return new YuiChainedMap(self, overrides);
	}
	
	static getKeys = function() {
		var keys = map ? variable_struct_get_names(map) : [];
		
		if parent {
			keys = array_union(keys, parent.getKeys());
		}
		
		return keys;
	}
	
	static hasKey = function(key) {
		return (map && variable_struct_exists(map, key))
			|| (parent && parent.hasKey(key));
	}
}