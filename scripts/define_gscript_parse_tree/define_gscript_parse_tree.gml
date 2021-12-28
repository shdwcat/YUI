enum GS_PST_TYPE {
	Expression,
	Statement,
}

/// @description defines the ParseTree for the GScript Parser
// TODO: rename to GscriptSyntaxDefinition
function define_gscript_parse_tree() {
		
	return {
		// expressions
		ArrayLiteral: [GS_PST_TYPE.Expression, "values"],
		Assign: [GS_PST_TYPE.Expression, "name", "value"],
		Binary: [GS_PST_TYPE.Expression, "left", "operator", "right"],
		Grouping: [GS_PST_TYPE.Expression, "expression"],
		Indexer: [GS_PST_TYPE.Expression, "object", "index"],
		Literal: [GS_PST_TYPE.Expression, "value"],
		Logical: [GS_PST_TYPE.Expression, "left", "operator", "right"],
		//Range: [GS_PST_TYPE.Expression, "range_start", "range_end"],
		Timespan: [GS_PST_TYPE.Expression, "value", "units"],
		Unary: [GS_PST_TYPE.Expression, "operator", "right"],
		Variable: [GS_PST_TYPE.Expression, "name"],
		
		Get: [GS_PST_TYPE.Expression, "object", "name"],
		TryGet: [GS_PST_TYPE.Expression, "object", "name"],
		
		// todo as statements
		Set: [GS_PST_TYPE.Expression, "object", "name", "value"],
		Call: [GS_PST_TYPE.Expression, "callee", "paren", "args"],
		
		// fiber instructions
		DelayStatement: [GS_PST_TYPE.Statement, "timespan"],
		KeyframeStatement: [GS_PST_TYPE.Statement, "timespan"],
		FrameStatement: [GS_PST_TYPE.Statement],
		
		// iteration
		ForStatement: [GS_PST_TYPE.Statement, "producer", "statement"],
		EachExpr: [GS_PST_TYPE.Expression, "itemName", "producer"],
		EveryExpr: [GS_PST_TYPE.Expression, "listName", "count", "producer"],
		Iterator: [GS_PST_TYPE.Expression, "source"],		
		BreakStatement: [GS_PST_TYPE.Statement],
		
		// other statements
		BlockStatement: [GS_PST_TYPE.Statement, "statements"],
		EventStatement: [GS_PST_TYPE.Statement, "event", "statement"],
		ExpressionStatement: [GS_PST_TYPE.Statement, "expression"],
		IfStatement: [GS_PST_TYPE.Statement, "condition", "thenBranch", "elseBranch"],
		PrintStatement: [GS_PST_TYPE.Statement, "expression"],
		VarStatement: [GS_PST_TYPE.Statement, "name", "initializer"],
		EmptyStatement: [GS_PST_TYPE.Statement],
	}
}