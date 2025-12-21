/// @description
function YsLambdaParselet(precedence) : GsplInfixParselet(precedence) constructor {
	
	static parse = function(parser, left_expr, token) {
		
		// track the previous context if one existed and set up a new context
		// (lambdas can be nested)
		var old_context = parser.context;
		parser.context = new YuiLambdaContext(old_context);
		
		// set up the args -> param name lookup
		if is_instanceof(left_expr, YuiIdentifier) {
			var param_name = left_expr.resolve();
			parser.context.arg_map = [param_name];
			
		}
		else if is_instanceof(left_expr, MxListExpression) {
			var type = instanceof(left_expr);
			var params_expr = left_expr;
			var param_count = array_length(params_expr.item_exprs);
			parser.context.arg_map = array_create(param_count);
			
			var i = 0; repeat param_count {
				var param_expr = params_expr.item_exprs[i];
				
				if !is_instanceof(param_expr, YuiIdentifier)
					throw yui_error($"expecting identifier in lambda params at index {i}, got {instanceof(param_expr)}");
				
				var param_name = param_expr.resolve();
				parser.context.arg_map[i] = param_name;
				i++;
			}
		}
		else {
			throw yui_error($"Arrow (=>) cannot be applied to left operand of type '{instanceof(left_expr)}`");
		}
		
		var body = parser.parseExpression(precedence);
		
		var lambda = new YuiLambda(body, parser.context);
		
		// reset the context to whatever it was before
		parser.context = old_context;
		
		return lambda;
	}
}

function YuiLambdaContext(parent = undefined) constructor {
	self.parent = parent;
	self.arg_map = undefined;
	
	// the actual param values filled in during execution time
	self.params = undefined;
	
	static isParamIdentifier = function(identifier_name) {
		
		if arg_map != undefined {
			
			if array_contains(arg_map, identifier_name) {
				return true;
			}
			else if parent != undefined {
				return parent.isParamIdentifier(identifier_name);
			}
		}
		
		// not a lambda param
		return false;
	}
	
	static getParamValue = function(param_name) {
			
		if struct_exists(params, param_name) {
			return params[$ param_name];
		}
		else if parent != undefined {
			return parent.getParamValue(param_name);
		}
	}
}