/// @description test GsScanner behavior
function gspl_test(test_file) {

	debug.debug_output = "";
	debug_log("testing file", test_file);
	
	// find the real data file
	var project_test_file = YUI_LOCAL_PROJECT_DATA_FOLDER + test_file;
	
	var source = string_from_file(project_test_file);
		
	var program = knit_parse(source);	
	if program == undefined {
		debug_log("failed to parse program");
		return;
	}
	
	var result = knit_run(program);		
	
	debug_log("done testing");
}