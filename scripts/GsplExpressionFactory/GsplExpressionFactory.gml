// TODO: what's above statements and expressions? SyntaxItem?

/// @description a factory for creating Expression instances from a parse tree definition
function GsplExpressionFactory(parse_tree_definition) constructor {
	self.parse_tree_definition = parse_tree_definition;
	
	// fill out the fields on this struct according to the parse tree definition
	var names = variable_struct_get_names(parse_tree_definition);
	var i = 0; repeat variable_struct_names_count(parse_tree_definition) {
		var key = names[i++];
		var expression_definition = parse_tree_definition[$key]; 
		
		var instance_factory = new GsplExpressionInstanceFactory(key, expression_definition);
		
		// need to store the factory so it doesn't get GC'd
		//self[$key + "Factory"] = instanceFactory;
		
		// store the factory under the expression name
		self[$key] = instance_factory.make;
	}

}

// creates a factory function for an expression definition
function GsplExpressionInstanceFactory(type, expression_definition) constructor {
	self.type = type;
	self.class = expression_definition[0];
	self.expression_definition = expression_definition;
	
	make = function(expression) {
		expression.type = type;
		
		// TODO: validate expression matches definition fields?
		
		// visitor pattern, e.g. if type is Binary, we want to call visitor.visitBinary(expression)
		var accept = function(visitor) {
			var visitor_function = visitor[$"visit" + type];
			if (visitor_function == undefined) {
				throw "unable to find visitor function: visit" + type;
			}
			
			// need to jump some hoops to call the method with the right scope
			var apply = method(visitor, visitor_function);
			return apply(self);
		};
		
		// need to do this in order for 'self' in accept to bind to the expression and not the factory
		expression.accept = method(expression, accept);
		
		return expression;
	}
}