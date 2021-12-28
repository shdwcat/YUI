/// @description clean up content item

event_inherited();

if content_item {
	instance_destroy(content_item);
}
