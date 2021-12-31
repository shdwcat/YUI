/// @description init

runner_temp_folder = yui_get_runner_temp_folder();

selection_scopes = ds_map_create();

themes = ds_map_create();
default_theme = new YuiTheme("yui_default", {});
themes[? "default"] = default_theme;

// TODO move to __yui_init_globals?
element_map = ds_map_create();
element_map[? "panel"] = YuiPanelElement;
element_map[? "text"] = YuiTextElement;
element_map[? "image"] = YuiImageElement;
element_map[? "line"] = YuiLineElement;
element_map[? "border"] = YuiBorderElement;
element_map[? "button"] = YuiButtonElement;
element_map[? "popup"] = YuiPopupElement;
element_map[? "switch"] = YuiSwitchElement;
element_map[? "data_template"] = YuiDataTemplateElement;