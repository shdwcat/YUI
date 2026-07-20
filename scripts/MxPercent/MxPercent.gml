/// @description here
function MxPercent(percent) constructor {
	
	self.percent = percent;
	
	// store the value as the decimal version so we can use it directly in math
	self.value = percent / 100.0;
	
	static toString = function() {
		return $"{percent}%";
	}
}

// used when parsing percents outside of an mx expression
function yui_parse_number_or_percent(expr_value) {
	static trim = ["%"];
	if is_string(expr_value) {
		if !string_ends_with(expr_value, "%")
			throw yui_error($"Expected number or percent value, got '{expr_value}'");
		
		var number_token = string_trim_end(expr_value, trim);
		var percent = real(number_token);
		return new MxPercent(percent);
	}
	else {
		return expr_value;
	}
}