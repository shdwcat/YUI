/// @description Value Type representing a timespan
function GsplTimeSpan(value, units) constructor {
	
	switch units._lexeme {
		case "milliseconds":
		case "ms":
			self.milliseconds = value;
			break;
		case "seconds":
		case "s":
			self.milliseconds = value * 1000;
			break;
		case "minutes":
		case "m":
			self.milliseconds = value * 1000 * 60;
			break;
		default:
			throw new GsplRuntimeError(units, "Unsupported timespan units: " + units._lexeme);
	}
	
	// defined how this type is iterated
	static __iterator = function() {
		return new GsplTimespanIterator(self);
	}
}