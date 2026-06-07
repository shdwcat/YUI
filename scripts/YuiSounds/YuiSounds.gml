/// @description here
function YuiSounds(sound_props, resources, slot_values) constructor {
	sounds = {};
	if sound_props != undefined {
		var sound_names = struct_get_names(sound_props);
		var i = 0; repeat array_length(sound_names) {
			var sound_name = sound_names[i++];
				
			var sound = yui_bind(sound_props[$ sound_name], resources, slot_values);
			sounds[$ sound_name] = sound;
		}
	}
	
	// returns the sound_id of the new sound
	// pass the previous sound_id to stop it first
	playSound = function(sound_name, data_source, sound_id = undefined) {
		var sound = sounds[$ sound_name];
		if sound != undefined {
			sound = yui_resolve_binding(sound, data_source);
			if !is_handle(sound) && sound == false
				return;
		
			if sound_id != undefined
				audio_stop_sound(sound_id);
		
			// todo: YUI_wide audio gain setting?
			return audio_play_sound(
				sound,
				YUI_DEFAULT_AUDIO_PRIORITY,
				false); // no loops
		}
	}
}