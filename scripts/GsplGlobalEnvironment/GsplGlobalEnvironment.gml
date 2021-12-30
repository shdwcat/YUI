/// @description the global environment shared by top level fibers
function GsplGlobalEnvironment() : GsplEnvironment() constructor {
	
	self.enclosing = new GsplGmlEnvironment();
	
	define("global", global);
	
	define("forever", new GsplForeverIterator());

	define("clock", gspl_define_clock());
	define("current_room", gspl_define_current_room());
}