/// @description base constructor for gspl callables
function GsplCallable() constructor {
		
	static arity = function() {
		throw "must override call in GsplCallable()";
	}

	static call = function(interpreter, args) {
		throw "must override call in GsplCallable()";
	}
}