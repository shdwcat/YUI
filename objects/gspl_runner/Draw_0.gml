/// @description do any draw instructions

if draw_fiber {
	
	// okay to ignore result because yield/etc is invalid inside these fibers
	draw_fiber.start();
	
	draw_fiber = undefined;
	instance_destroy(self);
}
