/// @description
function Cabinet(folder_path, extension, options, generator = undefined) constructor {

	self.folder_path = folder_path;
	self.extension = extension;
	self.generator = generator;
	
	//self.options = options ?? {};
	//self.options.file_options = options[$ "file_options"] ?? {}
	//self.options.file_options.cache_reads
	cache_reads = true;

	// flat view of the folder tree (indexed by full filepath)
	flat_map = {};
	
	// stores cached reads for any files in this cabinet
	cache = {};
	
	file_list = gumshoe(folder_path, extension);
	tree = gumshoe(folder_path, extension, true, __generateCabinetItem);
	
	static clearCache = function() {
		cache = {};
	}
	
	static __generateCabinetItem = function(directory, file, extension, index) {
		var result = new CabinetFile(self, {
			fullpath: directory + file,
			directory: directory,
			file: file,
			extension: extension,
		})
		
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
	
	scan_time = date_datetime_string(date_current_datetime());
	read_time = undefined;
	
	static tryLoadText = function() {
		
		// try to read the file
		var text = file_exists(fullpath) ? __readFileAsString(fullpath) : undefined;
		
		// if we read the file, cache it, track the time, and return it
		if text != undefined {
			cabinet.cache[$ fullpath] = text;
			read_time = date_datetime_string(date_current_datetime());
			return text;
		}
	}
	
	static tryReadText = function() {
		var cached_text = cabinet.cache[$ fullpath];
		if cached_text != undefined
			return cached_text;

		if cabinet.cache_reads
			return tryLoadText();
			
		if file_exists(fullpath)
			return __readFileAsString(fullpath);
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
