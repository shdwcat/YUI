/// @description reload UI

yui_cabinet.clearCache();
screens = {};
interactions = {};
yui_cabinet.rescan();

with yui_document {
	reload();
	yui_log("reloaded screen: " + yui_file);
}
