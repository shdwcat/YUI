/// @description built in clock() function, runtime since game started (in seconds)
function gspl_define_clock() {
	var clock = new GsplCallable();
	clock.arity = function() { return 0; };
	clock.call = function(interpreter, args) {
		return current_time / 1000.0;
	}
	clock.toString = function() { return "<native fn: clock()>"; }
	return clock;
}