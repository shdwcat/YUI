/// @description iterates over an array
function GsplArrayIterator(array) constructor {
	self.array = array;
	self.index = 0;
	self.count = array_length(array);
	
	static next = function() {
		// NOTE: have to do this here or index won't be correct in the return struct
		var value = array[index++];
		
		return {
			value: value,
			done: index >= count,
		}
	}
}