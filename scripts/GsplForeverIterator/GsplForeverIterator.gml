/// @description iterator that produces 'null' forever
function GsplForeverIterator() constructor {
	static null = gspl_null; // for performance

	static next = function() {
		return {
			value: null, // TODO: produced the elapsed time as a timespan?
			done: false, // never ends, must use break or some other way to interrupt
		}
	}
	
}