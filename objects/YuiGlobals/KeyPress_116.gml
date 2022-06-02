/// @description - reload interactions

// TODO clear cabinet cache, call document reloads from here

yui_cabinet.clearCache();
//yui_cabinet.rescan();

YuiCursorManager.interaction_map = yui_load_interactions();
yui_log("reloaded interactions");