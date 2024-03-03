/// @description
function YuiWindowItem(unique_id = undefined, top = 0, left = 0) constructor {
	self.unique_id = unique_id;
	self.top = top;
	self.left = left;
	self.visible = true;
	
	function onClosed(e) {
		yui_log($"onClosed not defined on window: {unique_id}");
	}
}