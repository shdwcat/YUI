/// @description iterator that, for the specified timespan, produces the elapsed time since it started
function GsplTimespanIterator(timespan) constructor {
	self.timespan = timespan;
	self.start_time = undefined;
	self.end_time = undefined;
	next();
	
	static null = gspl_null; // for performance

	static next = function() {
		var done = false;
		if start_time == undefined {
			start_time = current_time;
			end_time = current_time + timespan.milliseconds;
		}
		else {
			done = current_time > end_time;
		}
		
		return {
			value: current_time - start_time, // TODO: make an actual timespan to enable timespan math?
			done: done,
		}
	}
	
}