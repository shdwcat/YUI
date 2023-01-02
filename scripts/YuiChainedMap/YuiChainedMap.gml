/// @description implements a map with chainable parents
function YuiChainedMap(parent = undefined, values = undefined) constructor {
	self.parent = parent;
	self.map = values;
	
	static get = function(key) {
		if map && variable_struct_exists(map, key) {
			return map[$ key];
		}
		else if parent {
			return parent.get(key);
		}
		else {
			throw yui_error("slot key was not defined:", key);
		}	
	}
	
	static set = function(key, value) {
		self.map ??= {};
		map[$ key] = value;
	}
	
	static inherit = function(overrides) {
		return new YuiChainedMap(self, overrides);
	}
}