/// @description Iterator template (copy instead of inherit)
function GsplIteratorTemplate() constructor {

	static next = function() {
		return {
			value: undefined, // the next value in the iterator
			done: true, // whether the iterator is done
		}
	}
	
}