// credit for these goes to the incomparable Juju Adams

// Feather ignore GM2017
// Feather ignore GM1042

/// @param colour
function yui_color_get_luma(_colour)
{
    return (0.2126/255)*colour_get_red(_colour)
         + (0.7152/255)*colour_get_green(_colour)
         + (0.0722/255)*colour_get_blue(_colour);
}


/// @param colour
/// @param luma
function yui_color_set_luma(_colour, _newLuma)
{
    if (_colour == c_black) return make_colour_rgb(_newLuma, _newLuma, _newLuma);
    
    _newLuma = 255*clamp(_newLuma, 0, 1);
    if (_newLuma == 255) return c_white;
    
    var _r = colour_get_red(  _colour);
    var _g = colour_get_green(_colour);
    var _b = colour_get_blue( _colour);
    var _luma = 0.2126*_r + 0.7152*_g + 0.0722*_b;
    
    var _maxFactor = 255 / max(_r, _g, _b);
    var _factor = _newLuma / _luma;
    
    if (_factor <= _maxFactor)
    {
        //We can uniformly increase channel values without saturating any one of them
        _r *= _factor;
        _g *= _factor;
        _b *= _factor;
    }
    else
    {
        //We need to saturate at least one of the other channels to reach the desired luma
        //Inherently in the HSV colourspace this means our value is always maxed out
        //What we want to do is decrease the saturation whilst keep hue and value the same
        //This keeps our perception that we're seeing the same hue whilst increasing the luma to our target
        
        _r *= _maxFactor;
        _g *= _maxFactor;
        _b *= _maxFactor;
        
        _luma *= _maxFactor;
        
        //Interpolating from our current colour towards 255,255,255 is the same thing as reducing the saturation
        var _t = clamp((_newLuma - _luma) / (255 - _luma), 0, 1);
        _r = lerp(_r, 255, _t);
        _g = lerp(_g, 255, _t);
        _b = lerp(_b, 255, _t);
    }
    
    return make_colour_rgb(_r, _g, _b);
}

