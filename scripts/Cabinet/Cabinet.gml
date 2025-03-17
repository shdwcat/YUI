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
	
	static _force_lowercase = !_is_microsoft
		
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
		if cabinet.options.read_mode != "string" {
			throw "CabinetFile Error: cannot use tryScanLines when read_mode is: " + cabinet.options.read_mode;
		}
		
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
			case "binary":
				return __readFileAsBinary(fullpath);
		}
	}
	
	static __readFileAsBinary = function(filename) {
		var buffer = buffer_load(filename);
		return buffer;
	}
	
	// adapted from SNAP by Juju via https://github.com/JujuAdams/SNAP
	static __readFileAsString = function(_filename, _remove_bom = true) {

		var _buffer = buffer_load(_filename);

		if (_remove_bom && (buffer_get_size(_buffer) >= 4) && (buffer_peek(_buffer, 0, buffer_u32) & 0xFFFFFF == 0xBFBBEF))
		{
			buffer_seek(_buffer, buffer_seek_start, 3);
		}

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
	
	// whether to read files as strings or binary
	read_mode = options[$ "read_mode"] ?? "string";
	
	if read_mode != "string" && read_mode != "binary" {
		throw "CabinetOptions.read_mode must be either 'string' or 'binary'";
	}
	
	// function to convert the raw file contents into another value (e.g. a struct or sprite etc)
	file_value_generator = options[$ "file_value_generator"];
	
	// function to modify the CabinetFile with additional data
	cabinet_file_customizer = options[$ "cabinet_file_customizer"];
}