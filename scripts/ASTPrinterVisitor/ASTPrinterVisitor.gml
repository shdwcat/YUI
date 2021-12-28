/// @description Expression Visitor that prints the expression tree
function ASTPrinterVisitor() constructor {
		
	static print = function(expression) {
		return expression.accept(self);
	}
	
	static visitBinary = function(expression) {
		return parenthesize(expression.operator._lexeme, [expression.left, expression.right]);
	}
	
	static visitGrouping = function(expression) {
		return parenthesize("group", [expression.expression]);
	}
	
	static visitLiteral = function(expression) {
		if expression.value == undefined return "null";
		else return string(expression.value);
	}
	
	static visitUnary = function(expression) {
		return parenthesize(expression.operator._lexeme, [expression.right]);
	}
	
	static parenthesize = function(name, expressions) {
		var result = "(" + name
		var i = 0; repeat array_length(expressions) {
			var expr = expressions[i++];
			var expr_text = expr.accept(self);
			result += " " + expr_text;
		}
		result += ")";
		
		return result;
	}
}