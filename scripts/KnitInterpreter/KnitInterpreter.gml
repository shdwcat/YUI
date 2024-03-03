/// @description Interpreter that can run parsed Knit code
/// @param {struct.GsplEnvironment} environment
function KnitInterpreter(environment) constructor {
	
	self.environment = environment;

	// TODO registerGsplCallable()?
	self.callableTypes = {
		GsplCallable: GsplCallable,
		GsplCallableAsset: GsplCallableAsset, // gml scripts
		GsplCallableRuntimeFunction: GsplCallableRuntimeFunction, // built in functions
	};
	self.callableTypes[$"function"] = "function";
		
	static executeProgram = function(statements) {
		try {
			var i = 0; repeat array_length(statements) {
				var statement = statements[i++];
				if statement == undefined {
					gspl_log("skipping undefined statement at index " + string(i - 1));
				}
				else {
					execute(statement);
				}
			}
		}
		catch (error) {
			if instanceof(error) == "GsplRuntimeError" {
				gspl_show_runtime_error(error);
			}
			else throw error;
		}
	}
	
	static stringify = function(value) {
		if value == undefined return "null";
		if is_real(value) {
			var text = string(value)			
			return text;
		}
		if is_array(value) {
			var text = "[["; // need to escape for scribble
			var count = array_length(value);
			var i = 0; repeat count {
				text += stringify(value[i++]);
				if i != count text += ",";
			}
			text += "]";
			return text;
		}
		
		return string(value);
	}
	
	// === statement visitor functions ===
	
	static visitVarStatement = function(var_statement) {
		var value = undefined;
		if (var_statement.initializer != undefined) {
			value = evaluate(var_statement.initializer);
		}
		
		environment.define(var_statement.name._lexeme, value);
	}
	
	static visitBlockStatement = function(block_statement) {
		// TODO: how to handle KEYFRAME/DELAY in the middle of a block?
		// should all blocks get their own fibers?
		// okay I think the real way to do it is like environments, where
		// blocks have parents all the way up to a program, and when we enter a block
		// all we should do is set the current 'program' to the block, and then restore
		// the parent once the block is done.
		// Means tracking the block index with the program in which case that's just a fiber
		return executeBlock(block_statement.statements, new GsplEnvironment(environment));
	}
	
	static visitExpressionStatement = function(expr_statement) {
		evaluate(expr_statement.expression);
	}
	
	static visitIfStatement = function(if_statement) {
		var condition = evaluate(if_statement.condition)
		if isTruthy(condition) {
			return execute(if_statement.thenBranch);
		}
		else if if_statement.elseBranch != undefined {
			return execute(if_statement.elseBranch);
		}
	}
	
	static visitForStatement = function(statement) {
		var loop_env = new GsplEnvironment(environment);
		
		// swap in the loop environment when evaluating the producer (for the for-each case)
		// todo: try/catch?
		environment = loop_env;		
		var producer = evaluate(statement.producer);
		environment = loop_env.enclosing;
							
		// create the loop fiber and start it
		var fiber = new GsplLoopFiber(producer, statement.statement, loop_env, self);
		var result = fiber.start();
		return result;
	}
	
	static visitEventStatement = function(statement) {
		// create the fiber for the event block that will be run later
		var fiber = new GsplFiber([statement.statement], new GsplEnvironment(environment), self);
		
		// this is a bit awkward, we'd like to send the event to the runner here,
		// but this code currently lives in Interpreter, so we don't really have access
		// (it would technically still work since all interpreters are fibers currently)
		return new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.EVENT, {
			event_type: statement.event._type,
			fiber: fiber,
		});
	}
	
	static visitBreakStatement = function(frame_statement) {
		return new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.BREAK, undefined);
	}
	
	static visitDelayStatement = function(delay_statement) {
		var timespan = evaluate(delay_statement.timespan);
		return new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.DELAY, timespan);
	}
	
	static visitKeyframeStatement = function(keyframe_statement) {
		var timespan = evaluate(keyframe_statement.timespan);
		return new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.KEYFRAME, timespan);
	}
	
	static visitFrameStatement = function(frame_statement) {
		return new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.NEXT_FRAME, undefined);
	}
	
	static visitPrintStatement = function(print_statement) {
		var value = evaluate(print_statement.expression);
		var text = stringify(value);
		gspl_log(text);
	}
	
	static visitEmptyStatement = function() {
		// do nothing obviously :D
	}
	
	// === expression visitor functions ===
	
	static visitIterator = function(expr) {		
		var source = evaluate(expr.source);
		var iterator = makeIterator(source);
		return iterator;
	}
	
	static visitEachExpr = function(expr) {
		var producer = evaluate(expr.producer);
		var each_iterator = new GsplEachIterator(expr.itemName, producer, environment);
		return each_iterator;
	}
	
	static visitTimespan = function(expr) {
		var value = evaluate(expr.value);
		var timespan = new GsplTimeSpan(value, expr.units);
		return timespan;
	}
	
	static visitGet = function(get_expression) {
		var object = evaluate(get_expression.object);
		if object != undefined {
			if is_struct(object) || instance_exists(object) {
				var value = object[$ get_expression.name._lexeme];
				if value == undefined throw new GsplRuntimeError(get_expression.name,
					"Undefined variable '" + get_expression.name._lexeme + "' on '" + get_expression.object.name._lexeme + "'.");
				return value;		
			}
			else if ds_exists(object, ds_type_map) {
				var value = object[? get_expression.name._lexeme];
				if value == undefined throw new GsplRuntimeError(get_expression.name,
					"Undefined variable '" + get_expression.name._lexeme + "' on '" + get_expression.object.name._lexeme + "'.");
				return value;
			}
		}
		 // todo custom object types? get/call on literals?
		 
		 throw new GsplRuntimeError(get_expression.name, "Can only use . to get variables on instances/structs/ds_maps.");
	}
	
	static visitTryGet = function(get_expression) {
		var object = evaluate(get_expression.object);
		
		// TODO: how do we make this short circuit the rest of the expression?
		// consult: https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/expressions#unary-operators
		if object == undefined return undefined
		
		if is_struct(object) || instance_exists(object) {
			return object[$ get_expression.name._lexeme];
		}
		else if ds_exists(object, ds_type_map) {
			return object[? get_expression.name._lexeme];
		}
		 // todo custom object types? get/call on literals?
		 
		 throw new GsplRuntimeError(get_expression.name, "Can only use ?. to get variables on instances/structs/ds_maps.");
	}
	
	static visitIndexer = function(expr) {
		var object = evaluate(expr.object);
		if is_array(object) {
			var index = evaluate(expr.index);
			return object[index];
		}
		else if is_struct(object) {
			var index = evaluate(expr.index);
			return object[$ index];
		}
		else if ds_exists(object, ds_type_map) {
			var index = evaluate(expr.index);
			return object[? index];
		}
		else if ds_exists(object, ds_type_list) {
			var index = evaluate(expr.index);
			return object[| index];
		}
		else if ds_exists(object, ds_type_grid) {
			throw new GsplRuntimeError(get_expression.name, "ds_grid indexing is not yet supported");
		}
		
		throw new GsplRuntimeError(get_expression.name, "Can only use [] to index arrays/structs/maps/lists.");
	}
	
	static visitCall = function(call_expression) {
		var callee = evaluate(call_expression.callee);		
		if !isGsplCallable(callee) {
			throw new GsplRuntimeError(call_expression.callee.name, "Can only call functions and classes.");
		}
		
		var arguments = array_create(array_length(call_expression.args));
		var i = 0; repeat array_length(call_expression.args) {
			var arg = call_expression.args[i];
			arguments[i] = evaluate(arg);
			i++;
		}
		
		// if the callable has a known arity, validate the argument count
		var arity = callee.arity();			
		if arity != undefined && array_length(arguments) != arity {
			throw new GsplRuntimeError(call_expression.callee.name,
				"Expected " + string(arity) + " arguments but got " + string(array_length(arguments)) + ".");
		}
		
		return callee.call(self, arguments);
	}
	
	static isGsplCallable = function(callee) {
		var instance_type = instanceof(callee);
		if !is_string(instance_type) {
			throw "instance_type should be a string!";
		}
		return callee != undefined && variable_struct_exists(callableTypes, instance_type);
	}
	
	// TODO: convert to statement
	static visitAssign = function(assignment_expression) {
		var value = evaluate(assignment_expression.value);
		environment.assign(assignment_expression.name, value);
		return value; // TODO nope this should be a statement
	}
	
	static visitVariable = function(var_expression) {
		return environment.get(var_expression.name);
	}
	
	static visitArrayLiteral = function(expr) {
		var size = array_length(expr.values);
		var array = array_create(size);
		var i = 0; repeat size {
			array[i] = evaluate(expr.values[i]);
			i++;
		}
		
		return array;
	}
	
	static visitLogical = function(expression) {
		var left = evaluate(expression.left);
		
		if expression.operator._type == KNIT_TOKEN.OR {
			if isTruthy(left) return left;
		}
		else { // KNIT_TOKEN.AND
			if !isTruthy(left) return left;
		}
		
		return evaluate(expression.right);
	}
	
	static visitSet = function(set_expression) {
		var object = evaluate(set_expression.object);
		
		if object == undefined {
			throw new GsplRuntimeError(set_expression.object.name, "is not defined.");
		}
		
		if is_struct(object) || instance_exists(object) {
			var value = evaluate(set_expression.value);
			object[$ set_expression.name._lexeme] = value;
			return value;
		}
		else if ds_exists(object, ds_type_map) {
			var value = evaluate(set_expression.value);
			object[? set_expression.name._lexeme] = value;
			return value;
		}
		else {
			throw new GsplRuntimeError(set_expression.name, "Can only use . to set variables on instances/structs/ds_maps.");
		}
	}
	
	static visitBinary = function(expression) {
		var left = evaluate(expression.left);
		var right = evaluate(expression.right);
		
		switch expression.operator._type {
			case KNIT_TOKEN.MINUS:
				checkBinaryOperands("number", expression.operator, left, right);
				return real(left) - real(right);
			case KNIT_TOKEN.SLASH:
				checkBinaryOperands("number", expression.operator, left, right);
				if right == 0 throw new GsplRuntimeError(expression.operator, "Division by zero detected.");				
				return real(left) / real(right);
			case KNIT_TOKEN.STAR:
				checkBinaryOperands("number", expression.operator, left, right);
				return real(left) * real(right);
			case KNIT_TOKEN.PLUS:
				// TODO: string + number concat?
				if (is_real(left) && is_real(right)) {					
					return left + right;
				}
				else if is_string(left) {
					return left + string(right);
				}
				else if is_string(right) {
					return string(left) + right;
				}
				else
					throw new GsplRuntimeError(expression.operator,
						"Operands must be two numbers or one must be a string.")
				break;
				
			case KNIT_TOKEN.GREATER:
			{
				var early_result = checkComparisonOperands(expression.operator, left, right);
				if early_result != undefined return early_result;
				return real(left) > real(right);
			}
			case KNIT_TOKEN.GREATER_EQUAL:
			{
				var early_result = checkComparisonOperands(expression.operator, left, right);
				if early_result != undefined return early_result;
				return real(left) >= real(right);
			}
			case KNIT_TOKEN.LESS:
			{
				var early_result = checkComparisonOperands(expression.operator, left, right);
				if early_result != undefined return early_result;
				return real(left) < real(right);
			}
			case KNIT_TOKEN.LESS_EQUAL:
			{
				var early_result = checkComparisonOperands(expression.operator, left, right);
				if early_result != undefined return early_result;
				return real(left) <= real(right);
			}
				
			case KNIT_TOKEN.BANG_EQUAL:
				return !isEqual(left, right);
			case KNIT_TOKEN.EQUAL_EQUAL:
				return isEqual(left, right);
			case KNIT_TOKEN.DOT_DOT:
				return makeRange(expression.operator, left, right);
		}
	}
	
	static visitGrouping = function(expression) {
		return evaluate(expression.expression);
	}
	
	static visitLiteral = function(expression) {
		return expression.value;
	}
	
	static visitUnary = function(expression) {
		var right = evaluate(expression.right);
		
		switch expression.operator._type {
			case KNIT_TOKEN.BANG: // !
				return !isTruthy(right);
			case KNIT_TOKEN.MINUS: // -
				checkOperand("number", expression.operator, right);
				return -real(right);
		}
	}
	
	// === execute helpers ===
	
	static execute = function(statement) {
		if statement == undefined
			throw "can't execute undefined statement";
		
		return statement.accept(self);
	}
	
	// NOTE: we spin up a new fiber to execute the block in order to support delay/etc
	static executeBlock = function(statements, environment) {		
		var fiber = new GsplFiber(statements, environment, self);
		var block_result = fiber.start();
		return block_result;
	}
	
	static evaluate = function(expression) {
		return expression.accept(self);
	}
	
	static makeIterator = function(source) {
		if is_array(source)
			return new GsplArrayIterator(source);
		else if is_struct(source) {
			var __iter = source[$"__iterator"];
			if __iter != undefined {
				__iter = method(source, __iter);
				return __iter();
			}
			
		}
		
		throw "unsupported iterator source";
	}
	
	static isTruthy = function(value) {
		if value == undefined || value == gspl_null
			return false;
		else if is_bool(value)
			return value;
		else
			return true;
	}
	
	static isEqual = function(a, b) {
		return a == b;
		
		//if a == undefined && b == undefined
		//	return true;
		//if a == undefined
		//	return false;
		//else
		//	return a == b
	}
	
	// === error checking ===
	
	static checkOperand = function(type, operator, operand) {
		if typeof(operand) == type
			return;
		else
			throw new GsplRuntimeError(operator, "Operand must be a " + type + ": " + operand);
	}
	
	static checkBinaryOperands = function(type, operator, left, right) {
		if typeof(left) == type && typeof(right) == type
			return;
		else
			throw new GsplRuntimeError(operator, "Operands must be " + type + "s: " + string(left) + ", " + string(right));
	}
	
	static checkComparisonOperands = function(operator, left, right) {
		
		// check for undefined and null
		var is_left_undefined_or_null = left == undefined || left == gspl_null;
		var is_right_undefined_or_null = right == undefined || right == gspl_null;
		
		// if both are undefined or null, result is false
		if is_left_undefined_or_null && is_right_undefined_or_null return false;
		
		var left_is_number = typeof(left) == "number";
		var right_is_number = typeof(right) == "number";
		
		// if we're comparing a number and an undefined/null, result is false
		if (is_left_undefined_or_null && right_is_number)	|| (left_is_number && is_right_undefined_or_null)
			return false;
		
		if left_is_number && right_is_number
			return; // valid number comparison
		else
			throw new GsplRuntimeError(operator, "Operands must be numbers: " + string(left) + ", " + string(right));
	}
	
	// === misc ===	
	
	// TODO?: push to GsplRange, make array literal handle range literals
	static makeRange = function(operator, left, right) {
		// validate
		if !is_numeric(left) || frac(left) != 0 {
			throw new GsplRuntimeError(operator, "Left range operand must be an integer: " + string(left) + ".." + string(right) + ".");
		}
		if !is_numeric(right) || frac(right) != 0 {
			throw new GsplRuntimeError(operator, "Right range operand must be an integer: " + string(left) + ".." + string(right) + ".");
		}
		if left == right {
			throw new GsplRuntimeError(operator, "Range operator not valid for equal numbers: " + string(left) + ".." + string(right) + ".");
		}
		
		// for now create an array but we might want a proper range/iterator!
		
		var size = abs(right - left) + 1; // inclusive
		var range = array_create(size);
		var dir = left < right ? 1 : -1;
		
		var i = 0; var v = left repeat size {
			range[i] = v;
			i++; // increment to next index of the array
			v += dir; // increment or decrement value
		}
		
		return range;
	}
}