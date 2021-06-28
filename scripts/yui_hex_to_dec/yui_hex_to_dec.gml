// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function yui_hex_to_dec(hex_string) {
    var dec = 0;
 
    var dig = "0123456789ABCDEF";
    var len = string_length(hex_string);
    for (var pos=1; pos<=len; pos+=1) {
        dec = dec << 4 | (string_pos(string_char_at(hex_string, pos), dig) - 1);
    }
 
    return dec;
}