/// @description
function YuiWindowItem(unique_id = undefined, top = 0, left = 0) constructor {
	self.unique_id = unique_id;
	self.top = top;
	self.left = left;
	self.visible = true;
	
	self.onClosed = function(e) {
		yui_log("onClosed not set on window:", unique_id);
	}
}