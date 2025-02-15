/// @description here
function yui_do_live_reload() {
	with YuiGlobals {
		yui_cabinet.clearCache();
		screens = {};
		interactions = {};
		yui_cabinet.rescan();
	}

	yui_log("BEGIN: Triggered global reload");

	with yui_document {
		reload(true); // destroy now
		yui_log("reloaded screen: " + yui_file);
	}

	yui_log("END: Triggered global reload");
}