// Set this to true to enable verbose logging which will
// dump a lot of info in the log to help with debugging
#macro CABINET_VERBOSE_LOGGING false

/// @description scans a folder on disk for files and tracks information about the files found
/// @param {string} folder_path
/// @param {string} extension
/// @param options
function Cabinet(folder_path, extension = ".*", options = undefined) constructor {

	self.folder_path = folder_path;
	self.extension = extension;
	
	self.options = new CabinetOptions(options);
	
	// stores cached reads for any files in this cabinet
	cache = {};
	
	rescan();
	
	// regenerates the tree/file_list/flat_map from disk
	static rescan = function() {
		// flat view of the folder tree (indexed by full filepath)
		flat_map = {};
				
		file_list = gumshoe(
			folder_path,
			extension,
			/* returnStruct */ false,
			_force_lowercase,
			/* structValueGenerator */ undefined,
			/* forceForwardSlash */ true);
			
		tree = gumshoe(
			folder_path,
			extension,
			/* returnStruct */ true,
			_force_lowercase,
			__generateCabinetItem,
			/* forceForwardSlash */ true);
	}
	
	// clears the cached values for this Cabinet (and all associated CabinetFiles)
	static clearCache = function() {
		cache = {};
	}
	
	// gets the CabinetFile corresponding to the provided 'path' if it exists
	static file = function(path, is_included_file = true) {
		var file = flat_map[$ __fixPath(path, is_included_file)];
		if file == undefined && CABINET_VERBOSE_LOGGING {
			show_debug_message("Unable to find file:");
			show_debug_message($"Original path: {path}");
			show_debug_message($"Fixed path: {__fixPath(path, is_included_file)}");
			show_debug_message($"Known File List:");
			var paths = struct_get_names(flat_map);
			var i = 0; repeat array_length(paths) {
				show_debug_message($"  {paths[i++]}");
			}
		}
		return file;
	}
	
	// gets the content from the CabinetFile for the provided 'path' (possibly cached)
	static readFile = function(path) {
		var file = self.file(path);
		if file != undefined {
			return file.tryRead();
		}
	}
	
	// fixes the provided path by resolving '..' segments to the appropriate final directory
	static __fixPath = function(path, is_included_file) {
		var fixed_path = string_replace_all(path, "\\", "/");
		
		// resolve relative file paths
		var pos = string_pos("../", fixed_path);
		while pos != 0 {
			var previous_directory_pos = string_last_pos_ext("/", fixed_path, pos - 2);
			fixed_path = string_delete(fixed_path, previous_directory_pos, pos - previous_directory_pos + 2);
			
			pos = string_pos("../", fixed_path);
		}	
		
		// for included files on non-microsoft/non-mac platforms,
		// lowercase the file path to match the filenames that GM exports
		if _force_lowercase && is_included_file {
			fixed_path = string_lower(fixed_path)
		}
		
		return fixed_path;
	}
	
	// creates and tracks the CabinetFile for the provided file information,
	// and applies customization logic from cabinet options if present
	static __generateCabinetItem = function(directory, file, extension, index) {
		
		var fullpath = directory + file;
		
		var result = new CabinetFile(self, {
			fullpath: fullpath,
			directory: directory,
			file: file,
			extension: extension,
		});
		
		// apply customization
		if options.cabinet_file_customizer {
			options.cabinet_file_customizer(result);
		}
		
		// point the flat_map entry at the cabinet file
		flat_map[$ fullpath] = result;
		
		return result;
	}
	
	static _is_microsoft =
		os_type == os_windows
		|| os_type == os_uwp
		|| os_type == os_xboxone
		|| os_type == os_xboxseriesxs
		|| os_type == os_win8native
		|| os_type == os_winphone;
	
	static _force_lowercase = !_is_microsoft;
		
}

/// @description Tracks a data file found on disk by the associated Cabinet
/// @param {struct.Cabinet} cabinet the Cabinet associated with this CabinetFile
/// @param {struct} data the data for the file (directory, filename, etc)
function CabinetFile(cabinet, data) constructor {
	self.cabinet = cabinet;
	
	fullpath = data.fullpath;
	directory = data.directory;
	file = data.file;
	extension = data.extension;
	
	// calculate file_id (the name of the file without the extension)
	var filename_len = string_length(file);
	var extension_len = string_length(extension);
	file_id = string_copy(file, 1, filename_len - extension_len);
	
	scan_time = date_datetime_string(date_current_datetime());
	read_time = undefined;
	
	// Returns the contents of the file, from the cache if possible or from disk if it exists.
	// If a fileValueGenerator was specified in the cabinet options, that function
	// will be applied to the raw file content before returning (or caching) the value.
	static tryRead = function() {
		var cached_file = cabinet.cache[$ fullpath];
		if cached_file != undefined {
			if CABINET_VERBOSE_LOGGING show_debug_message($"Found file in cache: {fullpath}")
			return cached_file;
		}

		if cabinet.options.cache_reads {
			if CABINET_VERBOSE_LOGGING show_debug_message($"Loading file from disk (for cache): {fullpath}")
			var result = tryLoad();
			if CABINET_VERBOSE_LOGGING show_debug_message($"Found file on disk (for cache): {fullpath}")
			return result;
		}
			
		if CABINET_VERBOSE_LOGGING show_debug_message($"Loading file from disk (no caching): {fullpath}")
		if file_exists(fullpath) {
			if CABINET_VERBOSE_LOGGING show_debug_message($"Found file on disk: {fullpath}")
			return __readFile();
		}
		else if CABINET_VERBOSE_LOGGING show_debug_message($"File not found on disk: {fullpath}")
	}
	
	// if the file exists on disk, will load the file from disk and cache it, then return it
	static tryLoad = function() {
		
		// try to read the file
		var file_result = file_exists(fullpath) ? __readFile() : undefined;
		
		// if we read the file, cache it, track the time, and return it
		if file_result != undefined {
			cabinet.cache[$ fullpath] = file_result;
			read_time = date_datetime_string(date_current_datetime());
			return file_result;
		}
	}
	
	// Opens the associated file and scans lines one by one until match_line(line) returns a value
	// then returns that value.
	// Useful for reading 'header' info without loading the whole file into memmory.
	static tryScanLines = function(match_line) {
		if cabinet.options.read_mode == "string" {
			if file_exists(fullpath) {
				var file = file_text_open_read(fullpath)
			
				while !file_text_eof(file) {
					var line = file_text_readln(file);
					var match = match_line(line);
					if match != undefined {
						file_text_close(file);
						return match;
					}
				}
			
				file_text_close(file);
			}
		}
		else if cabinet.options.read_mode == "text_buffer" {
			var buffer = buffer_load(fullpath);
   
			var buffer_size = buffer_get_size(buffer)
			var line_start = buffer_tell(buffer)
			while(buffer_tell(buffer) < buffer_size) {
				var line = __buffer_read_line(buffer, buffer_size);
				
				var match = match_line(line);
				if match != undefined {
					buffer_delete(buffer);
					return match;
				}
			}
		}
		else if cabinet.options.read_mode == "binary" {
			throw "CabinetFile Error: cannot use tryScanLines when read_mode is: " + cabinet.options.read_mode;
		}
	}
	
	static __buffer_read_line = function(buffer, buffer_size) {
		var start = buffer_tell(buffer);
		
		// skip nulls or cr lf
		while(buffer_tell(buffer) < buffer_size) {
		    var value = buffer_peek(buffer, start, buffer_u8);
			
			if value == chr(0) || value == chr(10) || value == chr(13) {
				start++;
				buffer_seek(buffer, buffer_seek_relative, 1);
			}
			else {
				break;
			}
		}
		
		// find the end
		// TODO should use buffer_peek so we don't have to seek a bunch of times
		while(buffer_tell(buffer) < buffer_size) {
		    var value = buffer_read(buffer, buffer_u8);
			
			// break at null or cr lf (or end of buffer if we don't find one)
			if value == 0 || value == 10 || value == 13 {
				break;
			}
		}
		
		var _end = buffer_tell(buffer);
				
		// write a null so that we can read the string to this position
		// (currently don't need to fix it since we're throwing the buffer away at the end)
		buffer_poke(buffer, _end, buffer_u8, 0);
		
		// set the seek back to the start so that we can read the string
		buffer_seek(buffer, buffer_seek_start, start);
		
		// reads until the null we wrote with buffer_poke
		var line = buffer_read(buffer, buffer_string);
		
		// seek back to the end for the next line
		buffer_seek(buffer, buffer_seek_start, _end);
			
		return line;
	}
	
	// reads file content from disk according to options.read_mode
	static __readFile = function() {
		switch cabinet.options.read_mode {
			case "string":
				var text = __readFileAsString(fullpath);
				if cabinet.options.file_value_generator {
					return cabinet.options.file_value_generator(text, self);
				}
				else {
					return text;
				}
			case "text_buffer":
				var buffer = __readFileAsTextBuffer(fullpath);
				if cabinet.options.file_value_generator {
					return cabinet.options.file_value_generator(buffer, self);
				}
				else {
					return buffer;
				}
			case "binary":
				var buffer = __readFileAsBinary(fullpath);
				if cabinet.options.file_value_generator {
					return cabinet.options.file_value_generator(buffer, self);
				}
				else {
					return buffer;
				}
		}
	}
	
	static __readFileAsBinary = function(filename) {
		var buffer = buffer_load(filename);
		return buffer;
	}
	
	// adapted from SNAP by Juju via https://github.com/JujuAdams/SNAP
	// Reads the file into a buffer and skips the BOM marker if present
	// NOTE: if a BOM is present the buffet will be positioned after the BOM so don't reset to 0
	static __readFileAsTextBuffer = function(_filename, _remove_bom = true) {

		var _buffer = buffer_load(_filename);
		if (_remove_bom && (buffer_get_size(_buffer) >= 4) && (buffer_peek(_buffer, 0, buffer_u32) & 0xFFFFFF == 0xBFBBEF))
		{
			buffer_seek(_buffer, buffer_seek_start, 3);
		}
		return _buffer;
	}
	
	static __readFileAsString = function(_filename, _remove_bom = true) {
		var _buffer = __readFileAsTextBuffer(_filename, _remove_bom);
		
		// TODO handle file with BOM and nothing else
		if buffer_get_size(_buffer) == 0
			return "";
		
		var _string = buffer_read(_buffer, buffer_string);
		buffer_delete(_buffer);
		return _string;
	}
}

/// @description Options used by Cabinet. Created automatically from the options struct passed to Cabinet constructor.
function CabinetOptions(options = {}) constructor {
	// whether to cache file contents after reading once
	cache_reads = options[$ "cache_reads"] ?? true;
	
	// if set, a file will be reloaded if the timeout has elapsed since it was last read
	//cache_timeout = options[$ "cache_timeout"];
	
	// whether to read files as strings, text buffers, or binary buffers
	read_mode = options[$ "read_mode"] ?? "string";
	
	if read_mode != "string" && read_mode != "text_buffer" && read_mode != "binary" {
		throw "CabinetOptions.read_mode must be Fither 'string', 'text_buffer', or 'binary'";
	}
	
	// function to convert the raw file contents into another value (e.g. a struct or sprite etc)
	file_value_generator = options[$ "file_value_generator"];
	
	// function to modify the CabinetFile with additional data
	cabinet_file_customizer = options[$ "cabinet_file_customizer"];
}