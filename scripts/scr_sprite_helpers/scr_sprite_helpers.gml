function draw_sprite_flipped(_sprite, _subimg, _x, _y) {
    var _sprite_width = sprite_get_width(_sprite);
    var _sprite_xoffset = sprite_get_xoffset(_sprite);
    _sprite_xoffset *= 2;

    draw_sprite_ext(_sprite, _subimg, _x + _sprite_width - _sprite_xoffset, _y, -1, 1, 0, c_white, 1)
}