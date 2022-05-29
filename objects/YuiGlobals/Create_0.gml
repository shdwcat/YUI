/// @description init

runner_temp_folder = yui_get_runner_temp_folder();

selection_scopes = ds_map_create();

themes = ds_map_create();
default_theme = new YuiTheme("yui_default", {});
themes[? "default"] = default_theme;

