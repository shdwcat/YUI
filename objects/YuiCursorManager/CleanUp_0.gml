/// @description dispose

ds_list_destroy(focus_list);
ds_stack_destroy(focus_scope_stack);

ds_list_destroy(hover_list);
ds_map_destroy(highlight_map);
ds_map_destroy(participation_map);

