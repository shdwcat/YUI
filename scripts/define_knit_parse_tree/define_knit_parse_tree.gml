enum KNIT_PST_TYPE {
	Expression,
	Statement,
}

/// @description defines the ParseTree for the Knit Parser
// TODO: rename to KnitSyntaxDefinition
function define_knit_parse_tree() {
		
	return {
		// expressions
		ArrayLiteral: [KNIT_PST_TYPE.Expression, "values"],
		Assign: [KNIT_PST_TYPE.Expression, "name", "value"],
		Binary: [KNIT_PST_TYPE.Expression, "left", "operator", "right"],
		Grouping: [KNIT_PST_TYPE.Expression, "expression"],
		Indexer: [KNIT_PST_TYPE.Expression, "object", "index"],
		Literal: [KNIT_PST_TYPE.Expression, "value"],
		Logical: [KNIT_PST_TYPE.Expression, "left", "operator", "right"],
		//Range: [KNIT_PST_TYPE.Expression, "range_start", "range_end"],
		Timespan: [KNIT_PST_TYPE.Expression, "value", "units"],
		Unary: [KNIT_PST_TYPE.Expression, "operator", "right"],
		Variable: [KNIT_PST_TYPE.Expression, "name"],
		
		Get: [KNIT_PST_TYPE.Expression, "object", "name"],
		TryGet: [KNIT_PST_TYPE.Expression, "object", "name"],
		
		// todo as statements
		Set: [KNIT_PST_TYPE.Expression, "object", "name", "value"],
		Call: [KNIT_PST_TYPE.Expression, "callee", "paren", "args"],
		
		// fiber instructions
		DelayStatement: [KNIT_PST_TYPE.Statement, "timespan"],
		KeyframeStatement: [KNIT_PST_TYPE.Statement, "timespan"],
		FrameStatement: [KNIT_PST_TYPE.Statement],
		
		// iteration
		ForStatement: [KNIT_PST_TYPE.Statement, "producer", "statement"],
		EachExpr: [KNIT_PST_TYPE.Expression, "itemName", "producer"],
		EveryExpr: [KNIT_PST_TYPE.Expression, "listName", "count", "producer"],
		Iterator: [KNIT_PST_TYPE.Expression, "source"],		
		BreakStatement: [KNIT_PST_TYPE.Statement],
		
		// other statements
		BlockStatement: [KNIT_PST_TYPE.Statement, "statements"],
		EventStatement: [KNIT_PST_TYPE.Statement, "event", "statement"],
		ExpressionStatement: [KNIT_PST_TYPE.Statement, "expression"],
		IfStatement: [KNIT_PST_TYPE.Statement, "condition", "thenBranch", "elseBranch"],
		PrintStatement: [KNIT_PST_TYPE.Statement, "expression"],
		VarStatement: [KNIT_PST_TYPE.Statement, "name", "initializer"],
		EmptyStatement: [KNIT_PST_TYPE.Statement],
	}
}