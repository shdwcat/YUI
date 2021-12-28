/// @description empty constructor for sentinel values
/// (a sentinel is a value like 'undefined' which isn't numeric)
function Sentinel(type) constructor {
	self.type = type;
	
	static toString = function() { return "gspl_" + type; };
}