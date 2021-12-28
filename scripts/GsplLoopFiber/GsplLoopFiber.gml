/// @description A fiber that repeats the same statement until the iterator completes
function GsplLoopFiber(iterator, statement, environment, calling_fiber)
	: GsplFiber(undefined, environment, calling_fiber) constructor {
		
	self.iterator = iterator;
	self.statement = statement;
	self.complete = false;
	
	// === override GsplFiber 'program' iteration ===
		
	static getStatement = function() {
		return statement;
	}
	
	static moveNext = function() {
		var next = iterator.next();
		complete = next.done;
	}
	
	static isDone = function() {
		return complete;
	}
	
	static doBreak = function() {
		complete = true;
		if calling_fiber && calling_fiber.isPaused()
			calling_fiber.resume(undefined);
	}
	
	static base_handleInstruction = handleInstruction;
	static handleInstruction = function(instruction) {
		switch instruction.type {
			case GSPL_FIBER_INSTRUCTION.BREAK:
				doBreak();
				return;
			default:
				return base_handleInstruction(instruction);
		}
	}
}