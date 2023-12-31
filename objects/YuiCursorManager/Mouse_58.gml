/// @description

var items = [];
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];	
	array_push(items, next);
	i--;
}
		
inspector.show(items);