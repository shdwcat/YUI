/// @description do any drawgui instructions

if drawgui_fiber {
	
	// okay to ignore result because yield/etc is invalid inside these fibers
	drawgui_fiber.start();
	
	drawgui_fiber = undefined;
	instance_destroy(self);
}