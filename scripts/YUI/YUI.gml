// shared matrix for fast matrix operations
global.__YUI_QUICK_MATRIX = matrix_build_identity();
#macro YUI_QUICK_MATRIX global.__YUI_QUICK_MATRIX;

YUI();

// core access to global YUI functionality
function YUI() {
	// defines the Ys (YuiScript) parser behavior
	static Ys = new YsDefinition();
	
	static default_config = new YuiViewConfig(1, undefined);
	
	static view_config = default_config;
	
	static setViewConfig = function(config) {
		view_config = config;
	}
}

function YuiViewConfig(ui_scale, text_style_group) constructor {
	self.ui_scale = ui_scale;
	self.text_style_group = text_style_group;
}