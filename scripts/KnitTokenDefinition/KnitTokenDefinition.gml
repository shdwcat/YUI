function KnitTokenDefinition()
	: GsplTokenDefinition(
		KNIT_TOKEN.EOF,
		KNIT_TOKEN.STRING,
		KNIT_TOKEN.NUMBER,
		KNIT_TOKEN.IDENTIFIER) constructor {
	
	self.token_type = KnitToken;
	
	self.keywords = makeKeywordMap();
	
	static makeKeywordMap = function() {
		var map = {
			yield: KNIT_TOKEN.YIELD,
			null: KNIT_TOKEN.NULL,
			done: KNIT_TOKEN.DONE,
			each: KNIT_TOKEN.EACH,
			every: KNIT_TOKEN.EVERY,
			in: KNIT_TOKEN.IN,
			distinct: KNIT_TOKEN.DISTINCT,
			collect: KNIT_TOKEN.COLLECT,
			parallel: KNIT_TOKEN.PARALLEL,
			animate: KNIT_TOKEN.ANIMATE,
			delay: KNIT_TOKEN.DELAY,
			keyframe: KNIT_TOKEN.KEYFRAME,
			frame: KNIT_TOKEN.FRAME,
			when: KNIT_TOKEN.WHEN,
			emit: KNIT_TOKEN.EMIT,
			print: KNIT_TOKEN.PRINT,
			event: KNIT_TOKEN.EVENT,
			draw: KNIT_TOKEN.DRAW,
			drawgui: KNIT_TOKEN.DRAWGUI,
		}
		map[$"if"] = KNIT_TOKEN.IF;
		map[$"else"] = KNIT_TOKEN.ELSE;
		map[$"return"] = KNIT_TOKEN.RETURN;
		map[$"and"] = KNIT_TOKEN.AND;
		map[$"or"] = KNIT_TOKEN.OR;
		map[$"true"] = KNIT_TOKEN.TRUE;
		map[$"false"] = KNIT_TOKEN.FALSE;
		map[$"var"] = KNIT_TOKEN.VAR;
		map[$"do"] = KNIT_TOKEN.DO;
		map[$"for"] = KNIT_TOKEN.FOR;
		map[$"break"] = KNIT_TOKEN.BREAK;
		return map;
	}
}