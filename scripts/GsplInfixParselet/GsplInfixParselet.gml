/// @description
function GsplInfixParselet(precedence) constructor {
	self.precedence = precedence;

	static parse = function(parser, left_expr, token) {
		throw "must implement parse on " + instanceof(self);
	}

}