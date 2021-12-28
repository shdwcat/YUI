/// @description wrap get-only access to the 'room' built-in variable
function define_current_room() {
	var callable = new Callable();
	callable.arity = function() { return 0; };
	callable.call = function(interpreter, args) {
		return room;
	}
	callable.toString = function() { return "<native fn: current_room>"; }
	return callable;
}