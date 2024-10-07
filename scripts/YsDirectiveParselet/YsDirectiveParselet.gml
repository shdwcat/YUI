/// @description applies directives to a YsExpression
function YsDirectiveParselet() constructor {
	precedence = YS_PRECEDENCE.DIRECTIVE;
	
	static parse = function(parser, left_expr, token) {
		
		// parse all directives (comma separated)
		do {			
			var directive = parser.consume(YS_TOKEN.IDENTIFIER, "Expecting directive name after '|'");
			left_expr = applyDirective(left_expr, directive._literal, parser);
		} until !parser.match(YS_TOKEN.COMMA)
		
		return left_expr;
	}
	
	static applyDirective = function (expr, directive, parser) {
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
			
			// if the expr is a binding expression literal, parse it
			case "resolve":
				if is_instanceof(expr, YuiValueWrapper) {
					var expr_value = expr.resolve();
					if yui_is_binding_expr(expr_value) {
						var inner_expr = yui_parse_binding_expr(expr_value, parser.resources, parser.slot_values);
						expr = inner_expr;
					}
				}
				break;
			
			// TODO: gm_asset instead and allow any asset? what's the use case for that?
			case "gm_object":
				yui_warning($"gm_object directive is deprecated, use ~{expr.source} instead to access host functionality");
				expr = new YuiObjectBinding(expr);
				break;
				
			case "eval":
				expr.is_yui_live_binding = false;
				break;
				
			default:
				throw yui_error("unknown directive:", directive);
		}
		
		return expr;
	}
}