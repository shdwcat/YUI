function __input_string()
{
    // Self initialize
    static instance = new (function() constructor {
        
    #region Configuration
    
    auto_closevkb = true;   // Whether the 'Return' key closes the virtual keyboard
    auto_submit   = true;   // Whether the 'Return' key runs the submission trigger
    auto_trim     = true;   // Whether submit trims leading and trailing whitespace
    
    allow_empty   = false;  // Whether a blank field submission is treated as valid
    allow_newline = false;  // Whether to allow newline characters or swap to space
    
    max_length = 1000;  // Maximum text entry string length. Do not exceed 1024
    
    #endregion
    
    #region Initialization
    
    predialog = "";
    value     = "";
    
    backspace_hold_duration  = 0;
    tick_last                = 0;
    
    trigger   = undefined;
    async_id  = undefined;
    
    virtual_submit = false;
    async_submit   = false;
    
    keyboard_supported = ((os_type == os_operagx) || (os_browser != browser_not_a_browser)
                       || (os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux)
                       || (os_type == os_android) || (os_type == os_switch) || (os_type == os_uwp)
                       || (os_type == os_tvos) || (os_type == os_ios));
    
    // Set platform hint
    if ((os_type == os_xboxone) || (os_type == os_xboxseriesxs) 
    ||  (os_type == os_switch)  || (os_type == os_ps4) || (os_type == os_ps5))
    {
        // Suggest 'async' (dialog) on console
        platform_hint = "async";
    }
    else if ((os_browser != browser_not_a_browser)
    && ((os_type != os_windows) && (os_type != os_macosx) 
    &&  (os_type != os_operagx) && (os_type != os_linux)))
    {
        // Suggest 'async' (dialog) on non-desktop web
        platform_hint = "async";
    }
    else if ((os_type == os_android) || (os_type == os_ios) || (os_type == os_tvos)
    || (uwp_device_touchscreen_available() && (os_type == os_uwp)))
    {
        // Suggest virtual keyboard on mobile
        platform_hint = "virtual";
    }
    else
    {
        platform_hint = "keyboard";
    }
    
    #endregion
    
    #region Utilities
    
    trim = function(_string)
    {        
        var _char  = "";
        var _left  = 1;
        var _right = string_length(_string);
        
        repeat (_right)
        {
            // Offset left
            _char = ord(string_char_at(_string, _left));
            if ((_char > 8) && (_char < 14) || (_char == 32)) _left++; else break;
        }
        
        repeat (_right - _left)
        {
            // Offset right
            _char = ord(string_char_at(_string, _right));
            if ((_char > 8) && (_char < 14) || (_char == 32)) _right--; else break;
        }
        
        return string_copy(_string, _left, _right - _left + 1);
    };
    
    
    set = function(_string)
    {
        _string = string(_string);
        
        if ((os_type != os_windows) || !allow_newline)
        {
            // Filter carriage returns
            _string = string_replace_all(_string, chr(13), "");
        }
        
        if (((os_type == os_ios) || (os_type == os_tvos)) || !allow_newline)
        {
            // Filter newlines
            _string = string_replace_all(_string, chr(10), " ");
        }
        
        if (string_pos(chr(0x7F), _string) > 0)
        {
            // Filter delete character (fixes Windows and Mac quirk)
            _string = string_replace_all(_string, chr(0x7F), "");
        }
        
        // Enforce length
        var _max = max_length + ((os_type == os_android) ? 1 : 0);
        _string = string_copy(_string, 1, _max);
        
        // Left pad one space (fixes Android quirk on first character)
        var _trim = (string_char_at(_string, 1) == " ");
        if ((os_type == os_android) && !_trim)
        {
            // Set leading space
            _string = " " + _string;
            _trim = true;
        }
        
        //Update internal value
        if ((tick_last > (current_time - (delta_time div 1000) - 2))
        &&  (keyboard_string != _string))
        {
            if (((os_type == os_ios) || (os_type == os_tvos))
            && (string_length(keyboard_string) > _max))
            {
                // Close keyboard on overflow (fixes iOS string setting quirk)
                keyboard_virtual_hide();
            }
            
            // Set inbuilt value if necessary
            keyboard_string = _string;
        }
        
        value = _string;
        
        if ((os_type == os_android) && _trim)
        {
            //Strip leading space
            value = string_delete(value, 1, 1);
        }
    };
    
    
    submit = function()
    {
        if (auto_trim)
        {
            set(trim(input_string_get()));
        }
        
        if ((is_method(trigger) || is_numeric(trigger))
        && ((input_string_get() != "") || allow_empty))
        {
            trigger();
        }
    };
    
    
    tick = function()
    {
        if (keyboard_supported && (async_id == undefined))
        {
            // Manage text input
            var _string = keyboard_string;
            if ((_string == "") && (string_length(value) > 1))
            {
                // Revert internal string when in overflow state
                _string = "";
            }
            
            virtual_submit = false;
            if ((keyboard_virtual_status() != undefined) && !input_string_async_active())
            {            
                // Handle virtual keyboard submission
                if ((os_type == os_ios) || (os_type == os_tvos))
                {
                    virtual_submit = ((ord(keyboard_lastchar) == 10) 
                                   && (string_length(keyboard_string) > string_length(value)));
                }
                else if ((os_type == os_android) && keyboard_check_pressed(10))
                {
                    virtual_submit = true;
                }
                else
                {
                    // Keyboard submission
                    virtual_submit = (keyboard_check_pressed(vk_enter));
                }             
            
                if (auto_closevkb && virtual_submit
                && (((os_type == os_uwp) && uwp_device_touchscreen_available())
                ||   (os_type == os_ios) || (os_type == os_tvos) || (os_type == os_android)))
                {
                    // Close virtual keyboard on submission
                    keyboard_virtual_hide();
                }
            }
            
            if (_string != "")
            {
                // Backspace key repeat (fixes lack-of on native Mac and Linux)
                if ((os_browser == browser_not_a_browser) 
                &&  (os_type == os_macosx) || (os_type == os_linux))
                {
                    if (backspace_hold_duration > 0)
                    {
                        // Repeat on hold, normalized against Windows. Timed in microseconds
                        var _repeat_rate = 33000;
                        if (!keyboard_check(vk_backspace))
                        {
                            backspace_hold_duration = 0;
                        }
                        else if ((backspace_hold_duration > 500000)
                        && ((backspace_hold_duration mod _repeat_rate) > ((backspace_hold_duration + delta_time) mod _repeat_rate)))
                        {
                            _string = string_copy(_string, 1, string_length(_string) - 1);
                        }
                    }
                    
                    if (keyboard_check(vk_backspace))
                    {
                        backspace_hold_duration += delta_time;
                    }
                }
            }
            
            set(_string);
        }
                
        if (auto_submit && !async_submit
        && (virtual_submit || (keyboard_supported && keyboard_check_pressed(vk_enter))))
        {
            submit();
        }
        
        async_submit = false;
        tick_last = current_time;
    }
    
    #endregion
        
    })(); return instance;
}

function input_string_set(_string = "")
{
    gml_pragma("forceinline"); 
    
    if ((os_type == os_ios) || (os_type == os_tvos))
    {
        // Close virtual keyboard if string is manually set (fixes iOS setting quirk)
        keyboard_virtual_hide();
    }
    
    (__input_string()).set(_string);
}

function input_string_trigger_set(_trigger = undefined)
{
    gml_pragma("forceinline");
    
    if (!is_undefined(_trigger) && !is_method(_trigger)
    && (!is_numeric(_trigger) || !script_exists(_trigger)))
    {
        show_error
        (
            "Input String Error: Invalid value provided as trigger: \"" 
                + string(_trigger) 
                + "\". Expected a function or method.",
            true
        );
    }
    
    (__input_string()).trigger = _trigger;
}

function input_string_add(_string)
{
    gml_pragma("forceinline"); 
    return input_string_set((__input_string()).value + string(_string));
}

function input_string_virtual_submit() { gml_pragma("forceinline"); return (__input_string()).virtual_submit; }
function input_string_platform_hint()  { gml_pragma("forceinline"); return (__input_string()).platform_hint;  }
function input_string_submit()         { gml_pragma("forceinline"); return (__input_string()).submit();       }
function input_string_tick()           { gml_pragma("forceinline"); return (__input_string()).tick();         }
function input_string_get()            { gml_pragma("forceinline"); return (__input_string()).value;          }

