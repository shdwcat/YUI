/// @description
function YsLambdaParselet(precedence) : GsplInfixParselet(precedence) constructor {
	
	static parse = function(parser, left_expr, token) {
		
		// track the previous context if one existed and set up a new context
		// (lambdas can be nested)
		var old_context = parser.context;
		parser.context = {
			arg_map: undefined,
		};
		
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