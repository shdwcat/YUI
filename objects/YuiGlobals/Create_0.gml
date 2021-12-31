/// @description init

runner_temp_folder = yui_get_runner_temp_folder();

selection_scopes = ds_map_create();

themes = ds_map_create();
default_theme = new YuiTheme("yui_default", {});
themes[? "default"] = default_theme;

// TODO move to __yui_init_globals?
renderer_map = ds_map_create();
renderer_map[? "panel"] = YuiPanelRenderer;
renderer_map[? "text"] = YuiTextRenderer;
renderer_map[? "image"] = YuiImageRenderer;
renderer_map[? "line"] = YuiLineRenderer;
renderer_map[? "border"] = YuiBorderRenderer;
renderer_map[? "button"] = YuiButtonRenderer;
renderer_map[? "popup"] = YuiPopupRenderer;
renderer_map[? "switch"] = YuiSwitchRenderer;
renderer_map[? "data_template"] = YuiDataTemplateRenderer;

renderer_map[? "viewport"] = YuiNotImplemented;
renderer_map[? "checkbox"] = YuiNotImplemented;
renderer_map[? "slider"] = YuiNotImplemented;