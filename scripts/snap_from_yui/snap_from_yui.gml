// NOTE: This file is adapted from the original snap_from_yaml by @shdwcat
// Feather ignore GM1042

enum __SNAP_YUI
{
    INDENT = 0,
    NEWLINE = 1,
    ARRAY = 2,
    STRUCT = 3,
    SCALAR = 4,
    STRING = 5,
    JSON_ARRAY_START = 6,
    JSON_ARRAY_END = 7,
    JSON_STRUCT_START = 8,
    JSON_STRUCT_END = 9,
    JSON_COMMA = 10,
    JSON_COLON = 11,
}

/// @return Nested struct/array data that represents the contents of the YUI string
///
/// N.B. This is not a full implementation of the YAML spec and doesn't try to be. This YAML parser doesn't support:
///      1. Single quote delimited strings (you must use double quotes)
///      2. Block scalars using | and > prefixes
///      3. Anchors, documents, directives, nodes... all the weird extra stuff
///
/// @param string              The YUI string to be decoded
/// @param {bool} [replaceKeywords]   Whether to replace keywords (true, false, null) with boolean/undefined equivalents. Default to <true>
/// @param {bool} [trackFieldOrder]   Whether to track the order of struct fields as they appear in the YUI string (stored in __snap_field_order field on each GML struct). Default to <false>
///
/// @jujuadams 2020-09-20
function snap_from_yui(_string, _replace_keywords = true, _track_field_order = false)
{
	if _string == "" return undefined;
	
    var _buffer = buffer_create(string_byte_length(_string)+1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_seek(_buffer, buffer_seek_start, 0);

    var _tokens_array = (new __snap_from_yui_tokenizer(_buffer, _string)).result;
    buffer_delete(_buffer);

	var builder = (new __snap_from_yui_builder(_tokens_array, _replace_keywords, _track_field_order, _string));
    return builder.result;
}

#macro snap_from_yui_get_token_type tokens_array[token_index][0]
#macro snap_from_yui_get_token_value tokens_array[token_index][1]

// Feather ignore once GM2017
function __snap_from_yui_tokenizer(_buffer, _string) constructor
{
    buffer = _buffer;
    var _buffer_size = buffer_get_size(_buffer);

    var _tokens_array = [];
    result = _tokens_array;
	
	// used when handling escape chracters in strings
	partial_chunk = "";

	var _line          = 1;
    var _chunk_start   = 0;
    var _chunk_end     = 0;
    var _indent_search = true;
    var _json_depth    = 0;

    var _scalar_first_character = false;
    var _scalar_has_content     = false;
    var _in_string              = false;
    var _string_start           = undefined;
    var _in_comment             = false;

	// NOTE: _tell is passed so that we can return to the current position when done
    static read_chunk = function(_start, _end, _tell)
    {
        if (_end <= _start) return undefined;

        var _value = buffer_peek(buffer, _end, buffer_u8);
        buffer_poke(buffer, _end, buffer_u8, 0);

        buffer_seek(buffer, buffer_seek_start, _start);
        var _string = buffer_read(buffer, buffer_string);

        buffer_poke(buffer, _end, buffer_u8, _value);
        buffer_seek(buffer, buffer_seek_start, _tell);

		return _string;
    }
	
    static read_partial_chunk = function(_start, _end, _tell)
    {
		// include any partial chunk we have so far
		return partial_chunk + read_chunk(_start, _end, _tell);
    }

    static read_chunk_and_add = function(_start, _end, _tell, _type)
    {
        var _chunk = read_chunk(_start, _end, _tell);
		
		// include any partial chunk already read
		if partial_chunk != "" {
			_chunk = partial_chunk + _chunk;
			partial_chunk = "";
		}
		
		// add the chunk to the token array
        if (_chunk != undefined)
			result[@ array_length(result)] = [_type, _chunk];
    }

    while(buffer_tell(_buffer) < _buffer_size)
    {
        var _value = buffer_read(_buffer, buffer_u8);

        if (_in_comment)
        {
			// null or \r - exit comment parsing
            if ((_value == 0) || (_value == 13))
            {
                _chunk_start = buffer_tell(_buffer);
                _chunk_end   = buffer_tell(_buffer);

                _in_comment = false;
				_indent_search = true;
            }
			// \n - exit comment parsing and push new line
            if (_value == 10)
            {
                _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.NEWLINE, _line];
				_line++;
                _chunk_start = buffer_tell(_buffer);
                _chunk_end   = buffer_tell(_buffer);

                _in_comment    = false;
				_indent_search = true;
			}
        }
        else if (_indent_search)
        {
			// find the current indent level

            if (_value == 0)
            {
                break;
            }
			// \r - end chunk
            else if (_value == 13)
            {
                _chunk_start = buffer_tell(_buffer);
                _chunk_end   = buffer_tell(_buffer);
            }
			// \n - end chunk and push new line
            else if (_value == 10)
            {
                _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.NEWLINE, _line];
				_line++;
                _chunk_start = buffer_tell(_buffer);
                _chunk_end   = buffer_tell(_buffer);
            }
			// non-whitepace, so track indent level
            else if (_value > 32)
            {
                read_chunk_and_add(_chunk_start, buffer_tell(_buffer)-1, buffer_tell(_buffer), __SNAP_YUI.INDENT);

                buffer_seek(_buffer, buffer_seek_relative, -1);
                _chunk_start            = buffer_tell(_buffer);
                _chunk_end              = buffer_tell(_buffer);
                _indent_search          = false;
                _scalar_first_character = true;
                _scalar_has_content     = false;
            }
        }
        else
        {
			// First character on the line is a hyphen
            if (_scalar_first_character && (_value == 45))
            {
                var _next_value = buffer_peek(_buffer, buffer_tell(_buffer), buffer_u8);

                if ((_next_value == 10) || (_next_value == 13)) // new line
                {
                    _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.ARRAY];

                    _chunk_start   = buffer_tell(_buffer);
                    _chunk_end     = buffer_tell(_buffer);
                    _indent_search = false;
                }
                else if (_next_value == 32) // space
                {
                    _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.ARRAY];

                    buffer_seek(_buffer, buffer_seek_relative, 1);
                    _chunk_start = buffer_tell(_buffer);
                    _chunk_end   = buffer_tell(_buffer);
                }
                else if (_next_value == 45) //Two hyphens in a row
                {
					// match --- #
                    //if ((buffer_tell(_buffer) <= _buffer_size - 4)
					//	&& (buffer_peek(_buffer, buffer_tell(_buffer), buffer_u32) == ((35 << 24) | (32 << 16) | (45 << 8) | 45)))
                    //{
                    //    _in_comment = true;
                    //}
					// TODO: fix this for --- //
					// ...or write my own parser
                }
            }
			// two slashes in a row
			else if (_scalar_first_character
				&& (_value == 47 && buffer_peek(_buffer, buffer_tell(_buffer), buffer_u8) == 47))
			{
				_in_comment = true;
			}
            else
            {
                _scalar_first_character = false;

                if (_in_string)
                {
					// backlash escape supports \" \n \t \\
					if (_value == 92) {
						// read the partial chunk up to the escape (it will be added to the final string chunk)
						var _current_pos = buffer_tell(_buffer);
						partial_chunk = read_partial_chunk(_string_start, _current_pos-1, _current_pos);
						
						// read the escaped character and add it
						
						var _next_value = buffer_peek(_buffer, buffer_tell(_buffer), buffer_u8);
						
						if (_next_value == 34) // " (double quote)
							partial_chunk += "\"";
						else if (_next_value == 110) // letter n
							partial_chunk += "\n";
						else if (_next_value == 116)  // letter t
							partial_chunk += "\t";
						else if (_next_value == 92) // backslash
							partial_chunk += @"\";
						
						// reset string start to after the escaped character
						_string_start = _current_pos + 1;
						buffer_seek(_buffer, buffer_seek_relative, 1);
					}
					
					 // Quote " (except when escaped as \")
                    if ((_value == 34)
						&& (buffer_peek(_buffer, buffer_tell(_buffer)-2, buffer_u8) != 92))
                    {
                        read_chunk_and_add(_string_start, buffer_tell(_buffer)-1, buffer_tell(_buffer), __SNAP_YUI.STRING);
						
                        _chunk_start        = buffer_tell(_buffer);
                        _chunk_end          = buffer_tell(_buffer);
                        _in_string          = false;
                        _scalar_has_content = false;
                    }
                }
                else
                {
					// Whitespace
                    if (_value <= 32)
                    {
                        if (!_scalar_has_content) _chunk_start = buffer_tell(_buffer);
                    }
					// Not whitespace
                    else
                    {
                        _scalar_has_content = true;
                    }
					
					// mid scalar is when we are past the beginning of a scalar
					var _mid_scalar = _chunk_start != _chunk_end && _scalar_has_content;
					
					// Quote " - starts a new scalar but not if we're in the middle of a scalar, and not in json)
                    if (_value == 34 && !(_mid_scalar && _json_depth == 0))
                    {
                        _in_string = true;
                        _string_start = buffer_tell(_buffer);
                    }
					// // comment
					else if ((_value == 47 && buffer_peek(_buffer, buffer_tell(_buffer), buffer_u8) == 47)
						&& (buffer_tell(_buffer) >= 1) && (buffer_peek(_buffer, buffer_tell(_buffer)-2, buffer_u8) <= 32))
                    {
                        read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);

                        _chunk_start = buffer_tell(_buffer);
                        _chunk_end   = buffer_tell(_buffer);
                        _in_comment  = true;
                    }
					// [ ] { }
                    else if ((_value == 91) || (_value == 93) || (_value == 123) || (_value == 125))
                    {
                        // if we're in the middle of a scalar and not in json depth,
						// then we don't need to treat []{} as the end of the scalar
                        if _mid_scalar && _json_depth == 0 {
                            _chunk_end = buffer_tell(_buffer);
                        }
                        else {
                            read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);

                            if ((_value == 91) || (_value == 123)) // [ {
                            {
                                ++_json_depth;
                                _tokens_array[@ array_length(_tokens_array)] = [(_value == 91)? __SNAP_YUI.JSON_ARRAY_START : __SNAP_YUI.JSON_STRUCT_START];
                            }
                            else if ((_value == 93) || (_value == 125)) // ] }
                            {
                                --_json_depth;
                                _tokens_array[@ array_length(_tokens_array)] = [(_value == 93)? __SNAP_YUI.JSON_ARRAY_END : __SNAP_YUI.JSON_STRUCT_END];
                            }

                            _chunk_start        = buffer_tell(_buffer);
                            _chunk_end          = buffer_tell(_buffer);
                            _scalar_has_content = false;
                        }
                    }
					// Comma ,
                    else if ((_json_depth > 0) && (_value == 44))
                    {
                        read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);
                        _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.JSON_COMMA];

                        _chunk_start        = buffer_tell(_buffer);
                        _chunk_end          = buffer_tell(_buffer);
                        _scalar_has_content = false;
                    }
					// Colon :
                    else if (_value == 58)
                    {
                        if (_json_depth > 0)
                        {
                            read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);
                            _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.JSON_COLON];

                            _chunk_start        = buffer_tell(_buffer);
                            _chunk_end          = buffer_tell(_buffer);
                            _scalar_has_content = false;
                        }
                        else
                        {
                            read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);
                            _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.STRUCT];

                            var _next_value = buffer_peek(_buffer, buffer_tell(_buffer), buffer_u8);
							
							// Next value is a newline
                            if ((_next_value == 10) || (_next_value == 13))
                            {
                                _chunk_start   = buffer_tell(_buffer);
                                _chunk_end     = buffer_tell(_buffer);
                                _indent_search = false;
                            }
							// Next value is a space
                            else if (_next_value == 32)
                            {
                                buffer_seek(_buffer, buffer_seek_relative, 1);
                                _chunk_start            = buffer_tell(_buffer);
                                _chunk_end              = buffer_tell(_buffer);
                                _scalar_first_character = true;
                            }
                        }
                    }
					// Null or \r - end chunk
                    else if ((_value == 0) || (_value == 13))
                    {
                        read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);

                        _chunk_start = buffer_tell(_buffer);
                        _chunk_end   = buffer_tell(_buffer);
                    }
					// \n - end chunk and push new line
                    else if (_value == 10)
                    {
                        read_chunk_and_add(_chunk_start, _chunk_end, buffer_tell(_buffer), __SNAP_YUI.SCALAR);
                        _tokens_array[@ array_length(_tokens_array)] = [__SNAP_YUI.NEWLINE, _line];
						_line++;
                        _chunk_start = buffer_tell(_buffer);
                        _chunk_end   = buffer_tell(_buffer);
						
                        _indent_search = true;
                    }

					// move the chunk end forward
                    if (_value > 32) _chunk_end = buffer_tell(_buffer);
                }
            }
        }
    }
}

// Feather ignore once GM2017
function __snap_from_yui_builder(_tokens_array, _replace_keywords, _track_field_order, source) constructor
{
    tokens_array = _tokens_array;
    replace_keywords = _replace_keywords;
	track_field_order = _track_field_order;
	self.source = source;

    token_count  = array_length(tokens_array);
    token_index  = 0;

    indent = 0;
    line = 0;

    static read_to_next = function()
    {
        while(token_index < token_count)
        {
            var _type = snap_from_yui_get_token_type;
            if (_type == __SNAP_YUI.NEWLINE)
            {
                ++line;
                indent = 0;
            }
            else if (_type == __SNAP_YUI.INDENT)
            {
                var _indent_string = snap_from_yui_get_token_value;
                indent = string_count(" ", _indent_string); //TODO - Cache this value earlier during parsing
            }
            else
            {
                break;
            }

            ++token_index;
        }
    }

    static read = function()
    {
		if array_length(tokens_array) == 0
			return undefined;
		
        var _token = tokens_array[token_index];
        token_index++;

        var _type = _token[0];
        if ((_type == __SNAP_YUI.SCALAR) || (_type == __SNAP_YUI.STRING))
        {
            if (token_index < token_count && tokens_array[token_index][0] == __SNAP_YUI.STRUCT)
            {
                var _indent_limit = indent;
                var _struct = {};
				if (track_field_order) {
					var field_index = 0;
					_struct.__snap_field_order = [];
				}

                --token_index;
                while(token_index < token_count)
                {
                    var _key = tokens_array[token_index][1];

					if (track_field_order) {
						// add the key to the __snap_field_order array
						_struct.__snap_field_order[field_index++] = _key;
					}

                    token_index += 2; //Skip over the struct symbol

                    var _last_line = line;
                    read_to_next();
                    if ((indent <= _indent_limit) && (line != _last_line))
                    {
                        variable_struct_set(_struct, _key, undefined);
                    }
                    else
                    {
                        variable_struct_set(_struct, _key, read());
                    }

                    read_to_next();
                    if (indent < _indent_limit) break;
                }

                return _struct;
            }
            else
            {
				var _result = _token[1];
                if (_type == __SNAP_YUI.SCALAR)
                {
                    try 
                    {
                        _result = real(_result);
                        // It's a number
                    }
                    catch(_error)
                    {
                        // It's a string
                        if (replace_keywords)
                        {
                            switch(string_lower(_result))
                            {
                                case "true":  _result = true;      break;
                                case "false": _result = false;     break;
                                case "null":  _result = undefined; break;
                            }
                        }
                    }
                }

                return _result;
            }
        }
        else if (_type == __SNAP_YUI.ARRAY)
        {
            var _indent_limit = indent;
            var _array = [];

            --token_index;
            while(token_index < token_count)
            {
                if (snap_from_yui_get_token_type != __SNAP_YUI.ARRAY) break;
                ++token_index; //Skip over the array symbol

                var _last_line = line;
                read_to_next();
                if ((indent <= _indent_limit) && (line != _last_line))
                {
                    _array[@ array_length(_array)] = undefined;
                }
                else
                {
                    indent += 2;
                    _array[@ array_length(_array)] = read();
                }

                read_to_next();
                if (indent < _indent_limit) break;
            }

            return _array;
        }
        else if (_type == __SNAP_YUI.JSON_ARRAY_START)
        {
            var _array = [];

            read_to_next();
            while((token_index < token_count) && (snap_from_yui_get_token_type != __SNAP_YUI.JSON_ARRAY_END))
            {
                _array[@ array_length(_array)] = read();

                read_to_next();
                if (snap_from_yui_get_token_type == __SNAP_YUI.JSON_COMMA)
                {
                    token_index++;
                    read_to_next();
                }
            }

            token_index++;

            return _array;
        }
        else if (_type == __SNAP_YUI.JSON_STRUCT_START)
        {
            var _struct = {};
			if (track_field_order) {
				var field_index = 0;
				_struct.__snap_field_order = [];
			}

            read_to_next();
            while((token_index < token_count) && (snap_from_yui_get_token_type != __SNAP_YUI.JSON_STRUCT_END))
            {
                var _key = read();

				if (track_field_order) {
					// add the key to the __snap_field_order array
					_struct.__snap_field_order[field_index++] = _key;
				}

                read_to_next();
                if (snap_from_yui_get_token_type == __SNAP_YUI.JSON_COLON)
                {
                    token_index++;
                    read_to_next();
                }

                variable_struct_set(_struct, _key, read());

                read_to_next();
                if (snap_from_yui_get_token_type == __SNAP_YUI.JSON_COMMA)
                {
                    token_index++;
                    read_to_next();
                }
            }

            token_index++;

            return _struct;
        }
        else
        {
            throw "Unexpected error";
        }

        return undefined;
    }

    read_to_next();
    result = read();
}

// debug function for checking the token array in readable form
function __snap_from_yui_dump_tokens(tokens) {
	var str = "";
	var i = 0; repeat array_length(tokens) {
		var token = tokens[i++];
		switch token[0] {
		    case __SNAP_YUI.INDENT:
				str += $"INDENT '{token[1]}'\n";
				break;
		    case __SNAP_YUI.NEWLINE:
				str += $"NEWLINE {token[1] + 1}\n";
				break;
		    case __SNAP_YUI.ARRAY:
				str += "ARRAY\n";
				break;
		    case __SNAP_YUI.STRUCT:
				str += "STRUCT\n";
				break;
		    case __SNAP_YUI.SCALAR:
				str += $"SCALAR {token[1]}\n";
				break;
		    case __SNAP_YUI.STRING:
				str += $"STRING {token[1]}\n";
				break;
		    case __SNAP_YUI.JSON_ARRAY_START:
				str += "JSON_ARRAY_START\n";
				break;
		    case __SNAP_YUI.JSON_ARRAY_END:
				str += "JSON_ARRAY_END\n";
				break;
		    case __SNAP_YUI.JSON_STRUCT_START:
				str += "JSON_STRUCT_START\n";
				break;
		    case __SNAP_YUI.JSON_STRUCT_END:
				str += "JSON_STRUCT_END\n";
				break;
		    case __SNAP_YUI.JSON_COMMA:
				str += "JSON_COMMA\n";
				break;
		    case __SNAP_YUI.JSON_COLON:
				str += "JSON_COLON\n";
				break;
		}
	}
	
	clipboard_set_text(str);
}