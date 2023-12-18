enum GSPL_FIBER_INSTRUCTION {
	PAUSE, // pauses the current fiber (used when calling another fiber and waiting for it)
	
	YIELD,
	YIELD_VALUE,
	RETURN_VALUE,
	DONE,
	BREAK,
	
	EVENT,
	
	NEXT_FRAME,
	DELAY,
	KEYFRAME,
};

enum GSPL_FIBER_STATUS {
	CREATED,
	RUNNING,
	PAUSED,
	DONE,
	ERROR,
}

// TODO: invert this inheritance so that any AST Interpreter can inherit fiber behavior?
// Or use additive behavior like 'add_fiber_behavior'
// need to make GsplFiber not inherit KnitInterpreter

/// @description a fiber can run a program (statements) and yield to other fibers during execution
/// @param {array} gspl_program
/// @param {struct} environment
/// @param {struct.GsplFiber} calling_fiber
function GsplFiber(gspl_program, environment, calling_fiber = undefined)
	: KnitInterpreter(environment) constructor {
		
	static pauseFiber = new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.PAUSE, undefined);
		
	// the instructions to run
	self.program = gspl_program;
		
	// the fiber that created this fiber, if any;
	self.calling_fiber = calling_fiber;
	
	// the index of the current statement
	self.program_index = 0;
	
	// TODO: inherit from calling_fiber?
	// when this fiber started
	self.start_time = undefined;
	
	// the execution status of the fiber
	self.status = GSPL_FIBER_STATUS.CREATED;
	
	// the error thrown by running the program, if any
	self.error = undefined;
	
	// the gspl_runner managing frame by frame execution for this fiber (if any)
	self.runner = undefined; 
	
	// starts the fiber from the beginning
	static start = function() {
		if status == GSPL_FIBER_STATUS.RUNNING
			throw "cannot call .start() on a running fiber!";
		if status == GSPL_FIBER_STATUS.DONE
			throw "cannot call .start() on a finished fiber!";
		if status == GSPL_FIBER_STATUS.ERROR
			throw "cannot call .start() on a failed fiber!";
		
		status = GSPL_FIBER_STATUS.RUNNING;
		
		// TODO: need to pipe this through to block fibers as well
		start_time = current_time;
		
		try {
			var result = continueProgram();
			return result;
		}
		catch (error) {
			status = GSPL_FIBER_STATUS.ERROR;
			self.error = error;
			if runner runner.stop = true;
			if instanceof(error) == "GsplRuntimeError" {
				gspl_show_runtime_error(error);
			}
			else
				//throw error;
				gspl_log(error);
		}
	}
	
	// resumes execution after being paused
	static resume = function(resume_value) {
		if status = GSPL_FIBER_STATUS.RUNNING
			throw "cannot call .resume() on a running fiber!";
		if status == GSPL_FIBER_STATUS.DONE
			throw "cannot call .resume() on a finished fiber!";
		
		status = GSPL_FIBER_STATUS.RUNNING;
		
		try {
			var result = continueProgram(resume_value);
			return result;
		}
		catch (error) {
			status = GSPL_FIBER_STATUS.ERROR;
			self.error = error;
			if runner runner.stop = true;
			if instanceof(error) == "GsplRuntimeError" {
				gspl_show_runtime_error(error);
			}
			else
				//throw error;
				gspl_log(error);
		}
	}
		
	// creates a runner if needed and sends the instruction
	static sendRunnerInstruction = function(instruction) {
		if !runner {
			runner = instance_create_depth(-100, 50, 50, gspl_runner);
			runner.fiber = self;
		}
		gspl_set_runner_instruction(instruction);
	}
	
	static destroyRunner = function(runner_instance) {
		if runner_instance {
			instance_destroy(runner_instance);
		}
	}
	
	// creates a runner if needed and queues the event code
	static queueRunnerEvent = function(runner_event) {
		if !runner {
			runner = instance_create_depth(-100, 50, 50, gspl_runner);
		}
		// maybe use a different object since it can use less events?
		gspl_queue_runner_event(runner_event, runner_event.event_type == KNIT_TOKEN.DRAWGUI);
	}
	
	static getStatement = function() {
		try {
			return program[program_index];
		}
		catch (error)
		{
			throw error;
		}
	}
	
	static moveNext = function() {
		program_index++;
	}
	
	static isDone = function() {
		return status = GSPL_FIBER_STATUS.DONE
			|| program_index >= array_length(program);
	}
	
	static isPaused = function() {
		return status == GSPL_FIBER_STATUS.PAUSED;
	}
	
	// facilitates unrolling the fiber chain when we hit a 'break'
	// GsplIteratorFiber overrides this to actually handle the break behavior
	static doBreak = function() {
		if calling_fiber && calling_fiber.isPaused()
			calling_fiber.doBreak();
	}
	
	// executes the current program from the last pause point (or the start)
	static continueProgram = function(value) {
		// run until some instruction tells us to stop
		while status == GSPL_FIBER_STATUS.RUNNING {
			
			// TODO: need to rethink how advancement works to avoid this special case
			if isDone() {
				return handleInstruction(
					new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.DONE, gspl_done));
			}
			
			// get the next instruction
			var statement = getStatement();
			if statement == undefined
				throw "encountered undefined statement!";
						
			// run the statement
			var instruction = execute(statement);
			if instruction == undefined {
				// if the statement didn't return a fiber instruction, keep going
				moveNext();
				
				// check for program ending without return
				if isDone() {
					instruction = new GsplFiberInstruction(GSPL_FIBER_INSTRUCTION.DONE, gspl_done);
				}
				else
					continue;
			}
					
			return handleInstruction(instruction);
			
		}
	}
	
	static handleInstruction = function(instruction) {
		// evaluate the fiber instruction returned from the statement
		switch instruction.type {
						
			// pause current execution (e.g. b/c calling another fiber)
			case GSPL_FIBER_INSTRUCTION.PAUSE:
				status = GSPL_FIBER_STATUS.PAUSED;
				moveNext();
				return instruction;
						
			// done without producing a value
			case GSPL_FIBER_INSTRUCTION.DONE:
				status = GSPL_FIBER_STATUS.DONE;
				destroyRunner(runner);
				if calling_fiber && calling_fiber.isPaused()
					calling_fiber.resume(gspl_done);
				return;
						
			// break (ends the fiber chain until we hit an iterator)
			case GSPL_FIBER_INSTRUCTION.BREAK:
				status = GSPL_FIBER_STATUS.DONE;
				destroyRunner(runner);
				if calling_fiber && calling_fiber.isPaused() {
					calling_fiber.doBreak();
				}
				return instruction;
							
			// done with a value for the caller (if any)
			case GSPL_FIBER_INSTRUCTION.RETURN_VALUE:
				status = GSPL_FIBER_STATUS.DONE;
				destroyRunner(runner);
				if calling_fiber && calling_fiber.isPaused()
					calling_fiber.resume(instruction.value);
				return instruction.value;
				
			// paused without a value for the caller (if any)
			case GSPL_FIBER_INSTRUCTION.YIELD:
				status = GSPL_FIBER_STATUS.PAUSED;
				if calling_fiber && calling_fiber.isPaused()
					calling_fiber.resume(instruction.value); // TODO: gspl_nothing
				return;
				
			// paused with a value for the caller (if any)
			case GSPL_FIBER_INSTRUCTION.YIELD_VALUE:
				status = GSPL_FIBER_STATUS.PAUSED;
				if calling_fiber && calling_fiber.isPaused()
					calling_fiber.resume(instruction.value);
				return instruction.value;
				
			// use gspl runner to continue execution in the specified event
			case GSPL_FIBER_INSTRUCTION.EVENT:
				queueRunnerEvent(instruction.value);
				
				// event is only allowed inside 'animate' so we can keep going
				// as the queued events will be handled after the 'frame' call
				moveNext();
				break;
				
			// use a gspl_runner to continue execution on a future frame
			case GSPL_FIBER_INSTRUCTION.NEXT_FRAME:
				status = GSPL_FIBER_STATUS.PAUSED;
				sendRunnerInstruction(instruction);
					
				// proceed to the next statement on resume;
				moveNext();
				return pauseFiber;
				
			case GSPL_FIBER_INSTRUCTION.DELAY:
				status = GSPL_FIBER_STATUS.PAUSED;
				sendRunnerInstruction(instruction);		
				runner.delay_start_time = current_time;
					
				// proceed to the next statement on resume;
				moveNext();
				return pauseFiber;
					
			case GSPL_FIBER_INSTRUCTION.KEYFRAME:
				status = GSPL_FIBER_STATUS.PAUSED;
				sendRunnerInstruction(instruction);		
					
				// proceed to the next statement on resume;
				moveNext();
				return pauseFiber;
				
			default:
				// only hit this if we add an instruction type without adding a case here
				throw "unknown fiber instruction: " + string(instruction.type);
		}
	}
}

function GsplFiberInstruction(type, value) constructor {
	self.type = type;
	self.value = value;
}