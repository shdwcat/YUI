/// @description wraps an iterator to define each value in the environment
function GsplEachIterator(item_mame, iterator, environment) constructor {
	self.item_mame = item_mame;
	self.iterator = iterator;
	self.environment = environment
	environment.define(item_mame._lexeme);
	
	// kickstart the loop since fiber only calls moveNext() after the first statement
	// TODO: fix Fiber to call moveNext at the start
	next();

	static next = function() {
		var next = iterator.next();
		environment.assign(item_mame, next.value);		
		return next;
	}
	
}