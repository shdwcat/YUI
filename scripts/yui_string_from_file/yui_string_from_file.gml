// adapted and renamed from the original SNAP version

/// @return String that represents all the text inside the file
///
/// @param {string} filename     File to parse
/// @param {bool} [remove_bom]  Whether to look for the UTF8 byte order mark and remove it. Defaults to <true>
///
/// @jujuadams 2020-08-16

function yui_string_from_file(filename, remove_bom = true)
{
    var _buffer = buffer_load(filename);
    
    if (remove_bom && (buffer_get_size(_buffer) >= 4) && (buffer_peek(_buffer, 0, buffer_u32) & 0xFFFFFF == 0xBFBBEF))
    {
        buffer_seek(_buffer, buffer_seek_start, 3);
    }
    
    var _string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    return _string;
}