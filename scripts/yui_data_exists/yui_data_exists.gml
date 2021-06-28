// returns true if the data is defined (aka not undefined) and not noone
function yui_data_exists(data) {
	return data != noone && !is_undefined(data);
}