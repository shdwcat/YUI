// gets the expression table tracking compiled bindings
function yui_get_compiled_expr_table() {
	static expr_table = ds_map_create();
	return expr_table;
}

// compiles a binding to GML and tracks it in the compiled expression table
function yui_compile_binding(expr, source) {
	static expr_id = 0;
	static compiled_table = yui_get_compiled_expr_table();
	
	if !ds_map_exists(compiled_table, source) {
		
		var index = expr_id++;
		var func_name = "__yui_compiled_expr_" + string(index);
		
		var func_expr = expr.compile(func_name);
		
		if expr.is_lambda {
			// lambdas compile directly to the function GML
			var gml = func_expr;
			expr.compiled_script_name = func_name;
		}
		else {
			var return_token = expr.is_assign ? "" : "return ";
			var gml = "function " + func_name + "(data) {\n\t" + return_token + func_expr + "\n}\n\n";
		}
		
		compiled_table[? source] = {
			name: func_name,
			index: index,
			type: expr.checkType(),
			gml: gml,
			is_live: expr.is_yui_live_binding,
			is_call: expr.is_call,
			is_lambda: expr.is_lambda,
		}
	}
}

function yui_compile_functions_to_text() {
	static compiled_table = yui_get_compiled_expr_table();
	
	var expr_table_str =
		"// AUTO GENERATED - DO NOT EDIT\n"
		+ "// See YUI documentation to learn more\n\n"
		+ "function yui_get_function_table() {\n"
		+ "\tstatic makeTable = function() {\n"
		+ "\t\tvar table = ds_map_create();\n\n";
		
	var functions_str = "";
	
	var keys = ds_map_keys_to_array(compiled_table) ?? [];
	var entries = ds_map_values_to_array(compiled_table);
		
	// add the source to the entries
	var i = 0; repeat array_length(keys) {
		var source = keys[i];
		var entry = entries[i];
		entry.source = source;
		i++;
	}
	
	// sort them by index now that the source is included
	array_sort(entries, __yui_entry_sort);
	
	// build the function table and function definitions
	var i = 0; repeat array_length(entries) {
		var entry = entries[i];
		
		var type_str = entry.type != undefined
			? "\"" + entry.type + "\""
			: "undefined";
		
		// "foo": { id: yui_compiled_expr_0, type: "string", is_live: true },
		var table_row = "\t\ttable[? \"" + entry.source + "\"] =\n"
			+ "\t\t\t{ "
			+ "id: " + entry.name
			+ ", type: " + type_str
			+ ", is_live: " + (entry.is_live ? "true" : "false")
			+ ", is_call: " + (entry.is_call ? "true" : "false")
			+ ", is_lambda: " + (entry.is_lambda ? "true" : "false")
			+ " };\n\n";
			
		expr_table_str += table_row;
		
		functions_str += entry.gml;
		i++;
	}
	
	expr_table_str +=
		"\t\treturn table;\n"
		+ "\t}\n\n"
		+ "\tstatic func_table = makeTable();\n\n"
		+ "\treturn func_table;\n"
		+ "}\n\n";
	
	var file_text = expr_table_str + functions_str;
	return file_text;
}
function yui_write_compiled_functions_to_project() {
	static compiled_table = yui_get_compiled_expr_table();
	
	// if we didn't compile anything, leave the generated file alone
	if ds_map_size(compiled_table) == 0 return;
	
	var function_text = yui_compile_functions_to_text();
	
	static file_path = YUI_LOCAL_PROJECT_DATA_FOLDER + "../scripts/yui_compiled_functions/yui_compiled_functions.gml";

	var file = file_text_open_write(file_path);
	file_text_write_string(file, function_text);
	file_text_close(file);
	
	yui_log("YUI - Successfully compiled functions to disk");
}

function __yui_entry_sort(left, right) {
	return left.index - right.index;
}

function __ex_yui_get_function_table() {
	static makeTable = function() {
		var table = ds_map_create();
		table[? "foo"] = { id: yui_compiled_expr_0, type: "string", is_live: true };
		return table;
	}
	
	static func_table = makeTable();
	
	return func_table;
}

function __ex__yui_compiled_expr_0(data) {
	return data
}
