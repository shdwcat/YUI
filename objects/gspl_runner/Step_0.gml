/// @description run fiber logic until yield

// skip if stopped
if stop exit;

// handle any pending instruction
if instruction {
	switch instruction.type {
		case GSPL_FIBER_INSTRUCTION.NEXT_FRAME:			
			instruction = undefined;
			fiber.resume();			
			break;
			
		case GSPL_FIBER_INSTRUCTION.KEYFRAME:
			// wait until we've hit the keyframe
			if current_time - fiber.start_time > instruction.value.milliseconds {
				instruction = undefined;	
				fiber.resume();
			}		
			break;
			
		case GSPL_FIBER_INSTRUCTION.DELAY:
			// wait until we've hit the keyframe
			if current_time - delay_start_time > instruction.value.milliseconds {
				delay_start_time = undefined;
				instruction = undefined;
				fiber.resume();
			}
			break;
			
		default:
			throw "unsupported runner instruction: " + instruction.type;
	}
}