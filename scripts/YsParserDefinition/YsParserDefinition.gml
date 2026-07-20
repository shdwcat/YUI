/// @description here
function YsParserDefinition() : MxParserDefinition() constructor {

	prefix(YS_TOKEN.SLOT_IDENTIFIER, new YsSlotParselet());
	
	// override MxParserDefinition.initContext
	static initContext = function(parse_context) {
		// our slot parselet doesn't need to init the parse context
	}
}