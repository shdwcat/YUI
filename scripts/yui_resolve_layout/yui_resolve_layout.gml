function yui_resolve_layout() {
	var makeLayout = YuiGlobals.layout_map[$ props.layout];
	
	if makeLayout == undefined {
		throw yui_string_concat("Unknown panel layout:", props.layout);
	}
	
	return new makeLayout();
}