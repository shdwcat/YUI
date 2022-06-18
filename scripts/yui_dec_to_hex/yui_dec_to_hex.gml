/// @description
function yui_dec_to_hex(dec, len = 1) 
{
    static dig = "0123456789ABCDEF";

    var hex = "";

    if (dec < 0) {
        len = max(len, ceil(logn(16, 2 * abs(dec))));
    }

    while (len-- || dec) {
        hex = string_char_at(dig, (dec & $F) + 1) + hex;
        dec = dec >> 4;
    }

    return hex;
}
