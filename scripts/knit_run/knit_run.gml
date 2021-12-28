/// @description runs a provided knit program
function knit_run(program, environment = undefined) {
	
	// set up environment
	if environment == undefined {
		environment = new GsplGlobalEnvironment();
	}
	else if environment.enclosing == undefined {
		environment.enclosing = new GsplGlobalEnvironment();
	}

	// run program as fiber
	var fiber = new GsplFiber(program, environment);
	var result = fiber.start();
	return result;
}