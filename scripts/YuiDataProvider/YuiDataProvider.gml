
function YuiDataProvider(props) constructor {
	var constructorName = props[$ "constructor"];
	makeData = yui_get_script_by_name(constructorName);
	
	static getDataSource = function() {
		return new makeData();
	}
}