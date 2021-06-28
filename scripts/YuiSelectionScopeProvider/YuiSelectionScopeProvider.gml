/// @description here
function YuiSelectionScopeProvider(props) constructor {
	scope_id = props.scope_id;
	
	scope = yui_get_selection_scope(scope_id);
	
	static getDataSource = function() {		
		return scope;
	}
}