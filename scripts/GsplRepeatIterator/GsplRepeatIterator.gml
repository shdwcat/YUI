/// @description Iterator that repeats a value for the count (or forever if count is undefined)
function GsplRepeatIterator(value, count = undefined) constructor {
	self.value = value;
	self.count = count;

	static next = function() {
		var done = count == undefined || count-- > 0;
		return {
			value: value,
			done: done,
		};
	}
	
}