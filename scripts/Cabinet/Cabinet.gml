/// @description
function Cabinet(folder_path, extension = ".*", options = undefined, generator = undefined) constructor {

	self.folder_path = folder_path;
	self.extension = extension;
	self.generator = generator;
	
	self.options = new CabinetOptions(options);

	// flat view of the folder tree (indexed by full filepath)
	flat_map = {};
	
	// stores cached reads for any files in this cabinet
	cache = {};
	
	file_list = gumshoe(folder_path, extension);
	tree = gumshoe(folder_path, extension, true, __generateCabinetItem);
	
	static clearCache = function() {
		cache = {};
	}
	
	static file = function(path) {
		return flat_map[$ path];
	}
	
	static readFile = function(path) {
		var file = self.file(path);
		if file != undefined {
			return file.tryRead();
		}
	}
	
	static __generateCabinetItem = function(directory, file, extension, index) {
		
		var result = new CabinetFile(self, {
			fullpath: directory + file,
			directory: directory,
			file: file,
			extension: extension,
		});
		
		// apply customization
		if generator {
			generator(result);
		}
		
		// point the flat_map entry at the cabinet file
		flat_map[$ result.fullpath] = result;
		
		return result;
	}
}
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
	
	static tryLoad = function() {
		
		// try to read the file
		var file_result = file_exists(fullpath) ? __readFile(fullpath) : undefined;
		
		// if we read the file, cache it, track the time, and return it
		if file_result != undefined {
			cabinet.cache[$ fullpath] = file_result;
			read_time = date_datetime_string(date_current_datetime());
			return file_result;
		}
	}
	
	static tryRead = function() {
		var cached_file = cabinet.cache[$ fullpath];
		if cached_file != undefined
			return cached_file;

		if cabinet.options.cache_reads
			return tryLoad();
			
		if file_exists(fullpath)
			return __readFile(fullpath);
	}
	
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
	
	static __readFileAsBinary = function(_filename) {
		throw "TODO";
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
	
	file_value_generator = options[$ "file_value_generator"];
}


