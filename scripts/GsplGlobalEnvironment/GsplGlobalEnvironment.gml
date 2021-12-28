/// @description the global environment shared by top level fibers
function GsplGlobalEnvironment() : Environment() constructor {
	
	self.enclosing = new GmlEnvironment();
	
	define("global", global);
	
	define("forever", new GsplForeverIterator());

	define("clock", define_clock());
	define("current_room", define_current_room());
}