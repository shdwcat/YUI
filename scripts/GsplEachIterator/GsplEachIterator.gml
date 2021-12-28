/// @description wraps an iterator to define each value in the environment
function GsplEachIterator(itemName, iterator, environment) constructor {
	self.itemName = itemName;
	self.iterator = iterator;
	self.environment = environment
	environment.define(itemName._lexeme);
	
	// kickstart the loop since fiber only calls moveNext() after the first statement
	// TODO: fix Fiber to call moveNext at the start
	next();

	static next = function() {
		var next = iterator.next();
		environment.assign(itemName, next.value);		
		return next;
	}
	
}