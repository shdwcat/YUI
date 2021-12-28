/// @description
function ys_test(test_file, log_tokens = true) {
	
	debug.debug_output = "";
	debug_log("testing file", test_file);
	
	// find the real data file
	var project_test_file = YUI_LOCAL_PROJECT_DATA_FOLDER + test_file;
	
	var source = string_from_file(project_test_file);
	
	var token_def = new YsTokenDefinition();
	var scanner = new YsScanner(source, token_def);
	
	debug_log("scanning tokens");
	var tokens = scanner.scanTokens();
	
	if log_tokens {
		debug_log("found tokens:");
		var i = 0; repeat array_length(tokens) {
			debug_log(tokens[i++]);
		}
	}
	
	var parser = new YsParser(tokens, YS_TOKEN.EOF);
	
	var binding = parser.parseExpression();
	
	var data = {
		name: "test",
		test: {
			name: true,
		},
	};
	
	var result_val = binding.resolve(data);
	
	debug_log("parsed expr into result:", result_val);
}