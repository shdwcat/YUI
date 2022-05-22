// AUTO GENERATED - DO NOT EDIT
// See YUI documentation to learn more

function yui_get_function_table() {
	static makeTable = function() {
		var table = ds_map_create();

		table[? "@['is_equipped'] != true"] =
			{ id: __yui_compiled_expr_0, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "@source.data.sprite"] =
			{ id: __yui_compiled_expr_1, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@source.data.name"] =
			{ id: __yui_compiled_expr_2, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@source.data.slot == @target.data.slot"] =
			{ id: __yui_compiled_expr_3, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "yui_example_equip_item(@source.data /* the item */, @target.data /* the slot */)"] =
			{ id: __yui_compiled_expr_4, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "yui_log(`interaction 'equip_item' was cancelled`)"] =
			{ id: __yui_compiled_expr_5, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "@live_reload_label + ' - ' + @live_reload_message"] =
			{ id: __yui_compiled_expr_6, type: "string", is_live: true, is_call: false, is_lambda: false };

		table[? "@@ e => yui_change_screen(layout_example, e.source)"] =
			{ id: __yui_compiled_expr_7, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@@ e => yui_change_screen(kb_navigation_example, e.source)"] =
			{ id: __yui_compiled_expr_8, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@@ e => yui_change_screen(viewport_example, e.source)"] =
			{ id: __yui_compiled_expr_9, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@@ e => yui_change_screen(widget_gallery, e.source)"] =
			{ id: __yui_compiled_expr_10, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@@ e => yui_change_screen(inventory_screen, e.source)"] =
			{ id: __yui_compiled_expr_11, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@@ yui_example_exit_game()"] =
			{ id: __yui_compiled_expr_12, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "@@ e => yui_change_screen(welcome_screen, e.source)"] =
			{ id: __yui_compiled_expr_13, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$scroll_state.y = max($scroll_state.y - $scroll_state.info.y_max * 0.05, 0) >> round()"] =
			{ id: __yui_compiled_expr_14, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$scroll_state.y = min($scroll_state.y + $scroll_state.info.y_max * 0.05, $scroll_state.info.y_max) >> round()"] =
			{ id: __yui_compiled_expr_15, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$scroll_state.info.y_max > 0"] =
			{ id: __yui_compiled_expr_16, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "$vbar_visible|resolve then $bar_thickness else 0"] =
			{ id: __yui_compiled_expr_17, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$scroll_state.info.x_max > 0"] =
			{ id: __yui_compiled_expr_18, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "$hbar_visible|resolve then $bar_thickness else 0"] =
			{ id: __yui_compiled_expr_19, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@widget_data"] =
			{ id: __yui_compiled_expr_20, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@@ value => $scroll_state.info = value"] =
			{ id: __yui_compiled_expr_21, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$scroll_state.x"] =
			{ id: __yui_compiled_expr_22, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$scroll_state.y"] =
			{ id: __yui_compiled_expr_23, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$vbar_visible|resolve"] =
			{ id: __yui_compiled_expr_24, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "@@ e => $scroll_state.y = e.top * $scroll_state.info.y_max"] =
			{ id: __yui_compiled_expr_25, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$scroll_state.info.y_ratio * ($scroll_state.info.viewport_h - $thumb_size)"] =
			{ id: __yui_compiled_expr_26, type: "number", is_live: true, is_call: false, is_lambda: false };

		table[? "$hbar_visible|resolve"] =
			{ id: __yui_compiled_expr_27, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "@@ e => $scroll_state.x = e.left * $scroll_state.info.x_max"] =
			{ id: __yui_compiled_expr_28, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$scroll_state.info.x_ratio * ($scroll_state.info.viewport_w - $thumb_size)"] =
			{ id: __yui_compiled_expr_29, type: "number", is_live: true, is_call: false, is_lambda: false };

		table[? "@menu"] =
			{ id: __yui_compiled_expr_30, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$menu_items"] =
			{ id: __yui_compiled_expr_31, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@type"] =
			{ id: __yui_compiled_expr_32, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@check_state"] =
			{ id: __yui_compiled_expr_33, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@@ checked => @check_state = checked"] =
			{ id: __yui_compiled_expr_34, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$is_checked"] =
			{ id: __yui_compiled_expr_35, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$on_checked_changed(not $is_checked)"] =
			{ id: __yui_compiled_expr_36, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "@switcher_selector"] =
			{ id: __yui_compiled_expr_37, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@@ value => show_debug_message('selected ' + value)"] =
			{ id: __yui_compiled_expr_38, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$selection_scope.selected_index > 0"] =
			{ id: __yui_compiled_expr_39, type: "bool", is_live: true, is_call: false, is_lambda: false };

		table[? "$selection_scope.selectPreviousIndex()"] =
			{ id: __yui_compiled_expr_40, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$on_item_selected($selection_scope.selected_item)"] =
			{ id: __yui_compiled_expr_41, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$selection_scope.selected_item"] =
			{ id: __yui_compiled_expr_42, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$selection_scope.canSelectNextIndex()"] =
			{ id: __yui_compiled_expr_43, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$selection_scope.selectNextIndex()"] =
			{ id: __yui_compiled_expr_44, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "@switcher_items"] =
			{ id: __yui_compiled_expr_45, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "item => $selection_scope.select(item)"] =
			{ id: __yui_compiled_expr_46, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$items"] =
			{ id: __yui_compiled_expr_47, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@"] =
			{ id: __yui_compiled_expr_48, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "e => yui_invoke_event(e.source, item_selected, @)"] =
			{ id: __yui_compiled_expr_49, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "e => e.source.closePopup()"] =
			{ id: __yui_compiled_expr_50, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@@ value => @slider_value = value"] =
			{ id: __yui_compiled_expr_51, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "@slider_value"] =
			{ id: __yui_compiled_expr_52, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "$on_value_changed(min($value + $wheel_increment, $max))"] =
			{ id: __yui_compiled_expr_53, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$on_value_changed(max($value - $wheel_increment, $min))"] =
			{ id: __yui_compiled_expr_54, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "@@ e => $on_value_changed(e.left * ($max - $min))"] =
			{ id: __yui_compiled_expr_55, type: undefined, is_live: true, is_call: false, is_lambda: true };

		table[? "$value / ($max - $min) * ($size.w - $thumb_size.w + 10) - 10"] =
			{ id: __yui_compiled_expr_56, type: "number", is_live: true, is_call: false, is_lambda: false };

		table[? "$value >> string_format(0, 0)"] =
			{ id: __yui_compiled_expr_57, type: undefined, is_live: true, is_call: true, is_lambda: false };

		table[? "$value / ($max - $min),"] =
			{ id: __yui_compiled_expr_58, type: "number", is_live: true, is_call: false, is_lambda: false };

		table[? "@label"] =
			{ id: __yui_compiled_expr_59, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@children"] =
			{ id: __yui_compiled_expr_60, type: undefined, is_live: true, is_call: false, is_lambda: false };

		table[? "@@ not $is_checked"] =
			{ id: __yui_compiled_expr_61, type: undefined, is_live: true, is_call: false, is_lambda: false };

		return table;
	}

	static func_table = makeTable();

	return func_table;
}

function __yui_compiled_expr_0(data) {
	return (data[$ "is_equipped"] != true)
}

function __yui_compiled_expr_1(data) {
	return data.source.data.sprite
}

function __yui_compiled_expr_2(data) {
	return data.source.data.name
}

function __yui_compiled_expr_3(data) {
	return (data.source.data.slot == data.target.data.slot)
}

function __yui_compiled_expr_4(data) {
	return yui_example_equip_item(data.source.data, data.target.data)
}

function __yui_compiled_expr_5(data) {
	return yui_log("interaction 'equip_item' was cancelled")
}

function __yui_compiled_expr_6(data) {
	return ((string(data.live_reload_label) + " - ") + string(data.live_reload_message))
}

function __yui_compiled_expr_7(data, e) {
	yui_change_screen("layout_example", e.source)
}

function __yui_compiled_expr_8(data, e) {
	yui_change_screen("kb_navigation_example", e.source)
}

function __yui_compiled_expr_9(data, e) {
	yui_change_screen("viewport_example", e.source)
}

function __yui_compiled_expr_10(data, e) {
	yui_change_screen("widget_gallery", e.source)
}

function __yui_compiled_expr_11(data, e) {
	yui_change_screen("inventory_screen", e.source)
}

function __yui_compiled_expr_12(data) {
	return yui_example_exit_game()
}

function __yui_compiled_expr_13(data, e) {
	yui_change_screen("welcome_screen", e.source)
}

function __yui_compiled_expr_14(data) {
	var target = { x : 0, info : { x_ratio : 0, viewport_w : 0, y_ratio : 0, viewport_h : 0, x_max : 0, y_max : 0 }, y : 0 }
	target.y = round(max((0 - (0 + 0.05)), 0))
}

function __yui_compiled_expr_15(data) {
	var target = { x : 0, info : { x_ratio : 0, viewport_w : 0, y_ratio : 0, viewport_h : 0, x_max : 0, y_max : 0 }, y : 0 }
	target.y = round(min((0 + (0 + 0.05)), 0))
}

function __yui_compiled_expr_16(data) {
	return (0 > 0)
}

function __yui_compiled_expr_17(data) {
	return (0 > 0) ? 20 : 0
}

function __yui_compiled_expr_18(data) {
	return (0 > 0)
}

function __yui_compiled_expr_19(data) {
	return (0 > 0) ? 20 : 0
}

function __yui_compiled_expr_20(data) {
	return data.widget_data
}

function __yui_compiled_expr_21(data, value) {
	var target = { x : 0, info : { x_ratio : 0, viewport_w : 0, y_ratio : 0, viewport_h : 0, x_max : 0, y_max : 0 }, y : 0 }
	target.info = value
}

function __yui_compiled_expr_22(data) {
	return 0
}

function __yui_compiled_expr_23(data) {
	return 0
}

function __yui_compiled_expr_24(data) {
	return (0 > 0)
}

function __yui_compiled_expr_25(data, e) {
	var target = { x : 0, info : { x_ratio : 0, viewport_w : 0, y_ratio : 0, viewport_h : 0, x_max : 0, y_max : 0 }, y : 0 }
	target.y = (e.top + 0)
}

function __yui_compiled_expr_26(data) {
	return (0 + (0 - 20))
}

function __yui_compiled_expr_27(data) {
	return (0 > 0)
}

function __yui_compiled_expr_28(data, e) {
	var target = { x : 0, info : { x_ratio : 0, viewport_w : 0, y_ratio : 0, viewport_h : 0, x_max : 0, y_max : 0 }, y : 0 }
	target.x = (e.left + 0)
}

function __yui_compiled_expr_29(data) {
	return (0 + (0 - 20))
}

function __yui_compiled_expr_30(data) {
	return data.menu
}

function __yui_compiled_expr_31(data) {
	return data.menu
}

function __yui_compiled_expr_32(data) {
	return data.type
}

function __yui_compiled_expr_33(data) {
	return data.check_state
}

function __yui_compiled_expr_34(data, checked) {
	var target = data
	target.check_state = checked
}

function __yui_compiled_expr_35(data) {
	return data.check_state
}

function __yui_compiled_expr_36(data) {
	return __yui_compiled_expr_34(data, !(data.check_state))
}

function __yui_compiled_expr_37(data) {
	return data.switcher_selector
}

function __yui_compiled_expr_38(data, value) {
	show_debug_message(("selected " + string(value)))
}

function __yui_compiled_expr_39(data) {
	return (data.switcher_selector.selected_index > 0)
}

function __yui_compiled_expr_40(data) {
	return data.switcher_selector.selectPreviousIndex()
}

function __yui_compiled_expr_41(data) {
	return __yui_compiled_expr_38(data, data.switcher_selector.selected_item)
}

function __yui_compiled_expr_42(data) {
	return data.switcher_selector.selected_item
}

function __yui_compiled_expr_43(data) {
	return data.switcher_selector.canSelectNextIndex()
}

function __yui_compiled_expr_44(data) {
	return data.switcher_selector.selectNextIndex()
}

function __yui_compiled_expr_45(data) {
	return data.switcher_items
}

function __yui_compiled_expr_46(data, item) {
	data.switcher_selector.select(item)
}

function __yui_compiled_expr_47(data) {
	return data.switcher_items
}

function __yui_compiled_expr_48(data) {
	return data
}

function __yui_compiled_expr_49(data, e) {
	yui_invoke_event(e.source, "item_selected", data)
}

function __yui_compiled_expr_50(data, e) {
	e.source.closePopup()
}

function __yui_compiled_expr_51(data, value) {
	var target = data
	target.slider_value = value
}

function __yui_compiled_expr_52(data) {
	return data.slider_value
}

function __yui_compiled_expr_53(data) {
	return __yui_compiled_expr_51(data, min((data.slider_value + 4), 100))
}

function __yui_compiled_expr_54(data) {
	return __yui_compiled_expr_51(data, max((data.slider_value - 4), 0))
}

function __yui_compiled_expr_55(data, e) {
	__yui_compiled_expr_51(data, (e.left + (100 - 0)))
}

function __yui_compiled_expr_56(data) {
	return (((data.slider_value / (100 - 0)) + ((100 - 10) + 10)) - 10)
}

function __yui_compiled_expr_57(data) {
	return string_format(data.slider_value, 0, 0)
}

function __yui_compiled_expr_58(data) {
	return (data.slider_value / (100 - 0))
}

function __yui_compiled_expr_59(data) {
	return data.label
}

function __yui_compiled_expr_60(data) {
	return data.children
}

function __yui_compiled_expr_61(data) {
	return !(data.check_state)
}


