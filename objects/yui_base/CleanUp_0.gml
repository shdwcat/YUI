/// @description dispose

event_inherited();

if tooltip_item {
	instance_destroy(tooltip_item);
}

yui_unregister_interactions(interactions);
