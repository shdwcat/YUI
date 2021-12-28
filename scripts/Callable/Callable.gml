/// @description base constructor for gspl callables
function Callable() constructor {
		
	static arity = function() {
		throw "must override call in Callable()";
	}

	static call = function(interpreter, args) {
		throw "must override call in Callable()";
	}
}