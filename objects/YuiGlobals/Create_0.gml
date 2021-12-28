/// @description init

// check if we're in beta via the GM runtime version
// Beta is ##.blah
// Release is #.#.blah
// TODO: move this into yui_get_runner_temp_folder
var dot_pos = string_pos(".", GM_runtime_version)
var is_gms2_beta = dot_pos != 2;

runner_temp_folder = yui_get_runner_temp_folder(is_gms2_beta);

selection_scopes = ds_map_create();

themes = ds_map_create();
default_theme = new YuiTheme("yui_scifi", {});
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

layout_map = {
	vertical: YuiVerticalLayout,
	horizontal: YuiHorizontalLayout,
	overlay: YuiOverlayLayout,
	grid: YuiGridLayout,
	canvas: YuiCanvasLayout,
}

datasource_map = {
	data_provider: YuiDataProvider,
	selection_scope: YuiSelectionScopeProvider,
};