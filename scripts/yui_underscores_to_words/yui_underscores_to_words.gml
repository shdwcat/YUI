// converts "text_like_this" to "Text Like This"
function yui_underscores_to_words(text) {
	if is_undefined(text) return "";
	
	var tokens = yui_string_split(text, "_");
	
	var result = "";
	var i = 0; repeat array_length(tokens) {		
		if i > 0 result += " ";
		
		var token = tokens[i++];		
		var first_char = string_char_at(token, 1);		
		var word = string_upper(first_char) + string_copy(token, 2, string_length(token) - 1);		
		
		result += word;
	}
	
	return result;
}