/// @param directory
/// @param fileExtension
/// @param returnStruct
function gumshoe(_directory, _extension, _return_struct = false) {
    
    //Clean up weirdo directory formats that people might use
    _directory = string_replace_all(_directory, "/", "\\");
    if ((_directory != "") && (string_char_at(_directory, string_length(_directory)) != "\\")) _directory += "\\";
    
    //Clean up the extension too
    var _pos = string_pos(".", _extension);
    if (_pos > 0) _extension = string_delete(_extension, 1, _pos);
    _extension = "." + _extension;
    
    //Execute the inner function that we want
    if (_return_struct)
    {
        global.__gumshoe_count = 0;
        return __gumshoe_struct(_directory, _extension);
    }
    else
    {
        return __gumshoe_array(_directory, _extension, []);
    }
}

/// @param directory
/// @param fileExtension
/// @param resultArray
function __gumshoe_array(_directory, _extension, _result)
{
    var _directories = [];
    
    //Search through this directory
    var _file = undefined;
    while(true)
    {
        _file = (_file == undefined)? file_find_first(_directory + "*.*", fa_directory) : file_find_next();
        if (_file == "") break;
        
        if (directory_exists(_directory + _file))
        {
            //Process this directory
            _directories[@ array_length(_directories)] = _directory + _file + "\\";
        }
        else if ((_extension == ".*") || (filename_ext(_file) == _extension))
        {
            //Add this matching file to the output array
            _result[@ array_length(_result)] = _directory + _file;
        }
    }
    
    file_find_close();
    
    //Now handle the directories
    var _i = 0;
    repeat(array_length(_directories))
    {
        __gumshoe_array(_directories[_i], _extension, _result);
        ++_i;
    }
    
    return _result;
}

/// @param directory
/// @param fileExtension
function __gumshoe_struct(_directory, _extension)
{
    var _directories = [];
    var _result = {};
    
    //Search through this directory
    var _file = undefined;
    while(true)
    {
        _file = (_file == undefined)? file_find_first(_directory + "*.*", fa_directory) : file_find_next();
        if (_file == "") break;
        
        if (directory_exists(_directory + _file))
        {
            //Process this directory
            _directories[@ array_length(_directories)] = _file;
        }
        else if ((_extension == ".*") || (filename_ext(_file) == _extension))
        {
            //Add this matching file to the output array
            variable_struct_set(_result, _file, global.__gumshoe_count);
            ++global.__gumshoe_count;
        }
    }
    
    file_find_close();
    
    //Now handle the directories
    var _i = 0;
    repeat(array_length(_directories))
    {
        variable_struct_set(_result, _directories[_i], __gumshoe_struct(_directory + _directories[_i] + "\\", _extension));
        ++_i;
    }
    
    return _result;
}