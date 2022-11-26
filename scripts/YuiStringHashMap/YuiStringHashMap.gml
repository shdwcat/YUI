/// @description maps strings to unique IDs for faster comparison
function YuiStringHashMap(name) constructor {
	
	// a name for this hashmap for debugging convenience
	self.name = name;
	
	// the id to assign to the next new string
	next_id = 0;
	
	// the map of strings to IDs
	map = {};
	
	
	static getStringId = function(string) {
		return variable_struct_get(map, string) ?? addString(string);
	}
	
	// TODO reverse?
	static getString = function(hash_id) {	}
	
	static addString = function(string) {
		map[$ string] = next_id;
		return next_id++;
	}
	
	// converts an array of strings into an array of string hash ids
	static hashArray = function(array) {
		var i = 0; repeat array_length(array) {
			var item = array[i]
			if is_string(item) {
				var hash_id = getStringId(item);
				array[@ i] = hash_id;
			}
			i++;
		}
	}
}