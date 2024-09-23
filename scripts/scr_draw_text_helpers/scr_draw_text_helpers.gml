/// @function draw_text_advanced
/// @description
function draw_text_advanced(_x, _y, _text, _font = 0, _halign = 0, _valign = 0){
    var _game_font = draw_get_font();
    var _game_halign = draw_get_halign();
    var _game_valign = draw_get_valign();

    if (_font != 0){
        draw_set_font(_font);
    }
    if (_halign != 0){
        draw_set_halign(_halign);
    }
    if (_valign != 0){
        draw_set_valign(_valign);
    }

    draw_text(_x, _y, _text);

    draw_set_font(_game_font);
    draw_set_halign(_game_halign);
    draw_set_valign(_game_valign);
}