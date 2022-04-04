/// @description here
function yui_example_equip_item(item, slot) {
	//var item = params.item;
	//var slot = params.slot;
	
	var previous_item = slot.equipped_item;
	
	slot.equipped_item = item;
	
	// TODO: send previous item back to inventory pool
}