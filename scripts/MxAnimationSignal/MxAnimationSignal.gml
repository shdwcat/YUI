/// @description here
function MxAnimationSignal() constructor {
	self.version = 0; // version increments whenever the signal value is updated
	self.value = undefined; // animation to trigger on the next frame
	
	// adds the animation name to the list of animations to trigger on the next UI frame
	signal = function(animation_name) {
		value = animation_name;
		version++;
	}
	
	// FUTURE - way to check for when the animation is complete?
}