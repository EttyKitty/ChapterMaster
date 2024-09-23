function pressed_on_area(_x1, _y1, _x2, _y2, _mb = mb_left) {
    if (is_array(_x1)){
        return (mouse_check_button_pressed(_mb) && point_in_rectangle(mouse_x, mouse_y, _x1[0], _x1[1], _x1[2], _x1[3]));
	} else {
		return (mouse_check_button_pressed(_mb) && point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2));
	}
}

function holding_down_on_area(_x1, _y1, _x2, _y2, _mb = mb_left) {
    if (is_array(_x1)){
        return (mouse_check_button(_mb) && point_in_rectangle(mouse_x, mouse_y, _x1[0], _x1[1], _x1[2], _x1[3]));
	} else {
		return (mouse_check_button(_mb) && point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2));
	}
}

function scroll_on_area(_x1, _y1, _x2, _y2, _direction) {
    if (is_array(_x1)){
        if (_direction == 0){
            return (mouse_wheel_down() && point_in_rectangle(mouse_x, mouse_y, _x1[0], _x1[1], _x1[2], _x1[3]));
        } else {
            return (mouse_wheel_up() && point_in_rectangle(mouse_x, mouse_y, _x1[0], _x1[1], _x1[2], _x1[3]));
        }
	} else {
        if (_direction == 0){
            return (mouse_wheel_down() && point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2));
        } else {
            return (mouse_wheel_up() && point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2));
        }
	}
}

function scr_hit(_x1, _y1, _x2, _y2) {
	if (is_array(_x1)){
		return point_in_rectangle(mouse_x,mouse_y,_x1[0],_x1[1],_x1[2],_x1[3]);
	} else {
		return point_in_rectangle(mouse_x,mouse_y,_x1, _y1, _x2, _y2);
	}
}