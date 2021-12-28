/// @description YUI Test Data
function YuiTestData() constructor {
	
	text1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
	text2 = "do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	text3 = "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
	text4 = "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
	
	big_text_items = [text1, text2, text3, text4];
	
	test_menu = [
		new YuiMenuItem("Label One"),
		new YuiMenuItem("Label Two"),
		new YuiSubMenu("Submenu", , [
			new YuiMenuItem("Label Three"),
			new YuiMenuItem("Label Four"),			
			new YuiSubMenu("Sub-Submenu", , [
				new YuiMenuItem("Label Five"),
			]),
		]),
	];
}