// courtesy of TabularElf!

function __fileSystemGetSingleton() {
    static _instance = undefined;
    if (is_undefined(_instance)) {
        _instance = {
            filePath: game_save_id,
            isSandboxed: true
        }
        
        // Determine if Sandbox is enabled/disabled
        switch(os_type) {
            
            // Windows
            
            case os_windows: 
                _instance.filePath = environment_get_variable("userprofile") + "/";
            break;
            
             // Mac and Linux use the same instructions, but lead to different paths. 
             // "/Users/<username>" on macOS and "/home/<username>" on Ubuntu (Linux).
             
            // MacOSX & Linux
             
            case os_macosx: 
            case os_linux: 
                _instance.filePath = environment_get_variable("HOME") + "/"; 
            break;
            
            // This is for every other platform that's not desktop.
            
            default: 
                _instance.filePath = game_save_id; 
            break;
        }
    
        // We use this to determine whether or not Sandbox is enabled/disabled.
        if (os_type == os_windows || os_type == os_macosx || os_type == os_linux) && (os_browser == browser_not_a_browser) {
            // Attempt to create a file
            var _fpath = _instance.filePath + "test.fs";
            var _file =  file_text_open_append(_fpath);
            file_text_close(_file);
            if file_exists(_fpath) {
                // Check variables
                _instance.isSandboxed = false;
                file_delete(_fpath);
            } else {
                // Reset fileSystem path.
                _instance.filePath = game_save_id;
            }
        }        
    }
    
    return _instance;
}

/// @func yui_is_fs_sandbox_enabled()
function yui_is_fs_sandbox_enabled() {
    return __fileSystemGetSingleton().isSandboxed;
}

/// @func yui_filesystem_get()
function yui_filesystem_get() {
    return __fileSystemGetSingleton().filePath;
}