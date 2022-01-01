/// @description parse the script_text into an executable chunk
function knit_parse(script_text) {
	if script_text == undefined return;
	
	var scanner = new KnitScanner(script_text, new KnitTokenDefinition());
	
	var tokens = scanner.scanTokens();
	
	var log_tokens = false;
	if log_tokens {
		gspl_log("found tokens:");
		var i = 0; repeat array_length(tokens) {
			gspl_log(tokens[i++]);
		}
	}	
	
	var parse_tree_definition = define_knit_parse_tree();
	var parser = new KnitParser(tokens, KNIT_TOKEN.EOF, parse_tree_definition);
    var program = parser.parse();
	
	if parser.had_error {
		return;
	}
	else {
		return program;
	}
}