/// @description applies directives to a YsExpression
function YsDirectiveParselet() constructor {
	precedence = YS_PRECEDENCE.DIRECTIVE;
	
	static parse = function(parser, left_expr, token) {
		
		// parse all directives (comma separated)
		do {			
			var directive = parser.consume(YS_TOKEN.STRING, "Expecting directive name after '|'");
			left_expr = applyDirective(left_expr, directive._literal);
		} until !parser.match(YS_TOKEN.COMMA)
		
		return left_expr;
	}
	
	static applyDirective = function (expr, directive) {
		switch directive {
			case "trace":
				expr.trace = true;
				break;
			case "final":
			// TODO: maybe just wrap left_expr in a YuiFinalBinding?
				expr.dynamic_resolve = expr.resolve;
				with expr {
					resolve = function(data) {
						final_value = dynamic_resolve(data);
						resolve = function(data) {
							return final_value;
						}
						return final_value;
					}
				}
				break;
			// TODO: gm_asset instead and allow any asset? what's the use case for that?
			case "gm_object":
				expr = new YuiObjectBinding(expr);
				break;
			default:
				throw yui_error("unknown directive:", directive);
		}
		
		return expr;
	}
}