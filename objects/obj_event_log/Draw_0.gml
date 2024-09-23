function draw_help_panel() {
    var xx, yy, t, x1, y1, p1, y2;
    xx = __view_get(e__VW.XView, 0);
    yy = __view_get(e__VW.YView, 0);
    x1 = 0;
    y1 = 0;
    t = 0;

    draw_rectangle_color_simple(0, 0, room_width, room_height, 0, c_black, 0.75);
    draw_sprite(spr_help_panel, 0, xx, yy);
    draw_rectangle_color_outline(xx + 668, yy + 131, xx + 670 + 440, yy + 131 + 680, 2, c_black, 1, c_gray);
    if (scr_hit(xx + 1104, yy + 72, xx + 1137, yy + 105) = false) {
        draw_sprite(spr_help_exit, 0, xx + 1104, yy + 72);
    }
    if (scr_hit(xx + 1104, yy + 72, xx + 1137, yy + 105) = true) {
        draw_sprite(spr_help_exit, 1, xx + 1104, yy + 72);
        if (mouse_check_button_pressed(mb_left)) {
            with(obj_controller) {
                menu = 0;
                onceh = 1;
                cooldown = 8000;
                click = 1;
                hide_banner = 0;
            }
            help = 0;
            scroll_position = 0;
            topic = "";
        }
    }

    draw_rectangle_color_simple(xx + 466, yy + 136, xx + 644, yy + 166, 0, c_black);
    draw_rectangle_color_simple(xx + 466 + 1, yy + 136 + 1, xx + 644 - 1, yy + 166 - 1, 1, c_gray);
    draw_rectangle_color_simple(xx + 466 + 2, yy + 136 + 2, xx + 644 - 2, yy + 166 - 2, 1, c_gray);
    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_14b);
    draw_set_color(c_gray);
    draw_text(xx + 466 + 4, yy + 136 + 6, "Topics");
    x1 = xx + 466;
    y1 = yy + 166;
    repeat(20) {
        t += 1;
        if (topics[t] != "") {
            draw_set_alpha(0.75);
            if (topic = topics[t]) {
                draw_set_alpha(1);
            }
            draw_text(x1 + 2, y1 + 2, string(topics[t]));
            draw_set_alpha(1);
            if (scr_hit(x1, y1, x1 + 198, y1 + 22) = true) {
                draw_rectangle_color_simple(x1, y1, x1 + 198, y1 + 22, 0, c_gray, 0.2);
                if (mouse_check_button_pressed(mb_left)) {
                    obj_controller.cooldown = 8000;
                    scroll_position = 0;
                    topic = topics[t];
                    ini_open("main\\help.ini");
                    info = ini_read_string(string(t), "info", "");
                    strategy = ini_read_string(string(t), "strategy", "");
                    main_info = ini_read_string(string(t), "main_info", "");
                    related[1] = ini_read_string(string(t), "related_1", "");
                    related[2] = ini_read_string(string(t), "related_2", "");
                    related[3] = ini_read_string(string(t), "related_3", "");
                    ini_close();
                }
            }
            y1 += 24;
        }
    }
    // draw_set_color(c_gray);
    // draw_set_halign(fa_center);
    // draw_rectangle(xx+664,yy+148,xx+805,yy+316,0);
    if (topic != "") {
        if (!surface_exists(topic_article_surface)){
            topic_article_surface = surface_create(440, 800);
        }
        surface_set_target(topic_article_surface);
        draw_clear_alpha(c_black, 0);
        draw_set_font(fnt_40k_14b);
        draw_text_transformed(0, 0, string(topic), 1.25, 1.25, 0);
        draw_set_halign(fa_left);
        if (info != "") {
            draw_text(0, 50, "Game Info:");
        }
        draw_set_font(fnt_40k_14b);
        y2 = 0;
        p1 = string(info);
        if (info != "") {
            draw_text_ext(0, 70, string(p1), -1, 440);
        }
        if (info = "") {
            y2 -= 40;
        }
        if (strategy != "") {
            y2 += string_height_ext(string(p1), -1, 440) + 20;
            y2 += 20;
            p1 = string(strategy);
            draw_set_font(fnt_40k_14b);
            draw_text(0, 70 + y2, "Strategy:");
            draw_set_font(fnt_40k_14b);
            y2 += 20;
            draw_text_ext(0, 70 + y2, string(p1), -1, 440);
        }
        if (main_info != "") {
            y2 += string_height_ext(string(p1), -1, 440) + 20;
            p1 = string(main_info);
            draw_set_font(fnt_40k_14b);
            draw_text(0, 70 + y2, "Info:");
            draw_set_font(fnt_40k_14b);
            y2 += 20;
            draw_text_ext(0, 70 + y2, string(p1), -1, 440);
        }
        if (related[1] != "") {
            y2 += string_height_ext(string(p1), -1, 440) + 20;
            p1 = "";
            if (related[1] != "") {
                p1 += string(related[1]);
            }
            if (related[2] != "") {
                p1 += ", " + string(related[2]);
            }
            if (related[3] != "") {
                p1 += ", " + string(related[3]);
            }
            p1 += ".";
            draw_set_font(fnt_40k_14b);
            draw_text(0, 70 + y2, "See Also:");
            draw_set_font(fnt_40k_14b);
            y2 += 20;
            draw_text_ext(0, 70 + y2, string(p1), -1, 440);
        }
        // Draw the surface on the screen
        surface_reset_target();
        if (scroll_on_area(xx + 668, yy + 131, xx + 670 + 440, yy + 131 + 680, 0) && scroll_position < 680) {
            scroll_position += 40;
        } else if (scroll_on_area(xx + 668, yy + 131, xx + 670 + 440, yy + 131 + 680, 1) && scroll_position != 0) {
            scroll_position -= 40;
        }
        draw_surface_part(topic_article_surface, 0, scroll_position, 440, 680, xx + 670, yy + 131);
        if (surface_exists(topic_article_surface)){
            surface_free(topic_article_surface);
        }
        // Draw the scroll bar
        var scroll_bar_x = xx + 670 + 440;
        var scroll_bar_y = yy + 131 + (scroll_position);
        draw_set_color(c_gray);
        draw_rectangle(scroll_bar_x, scroll_bar_y, scroll_bar_x + 20, scroll_bar_y + 40, false);
        if (holding_down_on_area(scroll_bar_x, scroll_bar_y, scroll_bar_x + 20, scroll_bar_y + 40, mb_left)) {
            scrollbar_grabbed = true;
            scrollbar_offset = mouse_y - scroll_bar_y;
        }
        if (scrollbar_grabbed) {
            scroll_bar_y = mouse_y - scrollbar_offset;
            scroll_bar_y = clamp(scroll_bar_y, yy + 131, yy + 131 + 680 - 40);
            scroll_position = clamp((scroll_bar_y - yy - 131) * 2, 0, 680);
            if (mouse_check_button_released(mb_left)) {
                scrollbar_grabbed = false;
            }
        }
    }
}

var __b__;
__b__ = action_if_variable(help, 0, 0);
if (__b__) {
    var bad = 1;
    if (instance_exists(obj_controller)) {
        if (obj_controller.menu = 17) {
            bad = 0;
        }
    }
    if (bad = 0) {
        var ent;
        var xx = __view_get(e__VW.XView, 0) + 0;
        var yy = __view_get(e__VW.YView, 0) + 0;
        draw_set_alpha(1);
        draw_set_color(0);
        draw_rectangle(xx, yy, xx + 1600, yy + 900, 0);
        draw_set_alpha(0.5);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_alpha(1);
        draw_set_color(c_gray); // 38144
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text(xx + 800, yy + 74, string_hash_to_newline(string(global.chapter_name) + " Event Log"));
        draw_set_halign(fa_left);
        var t = 0,
            p = -1,
            cur_event;
        var ent = array_length(event);
        draw_set_color(38144);
        if (ent == 0) {
            draw_text(xx + 25, yy + 120, string_hash_to_newline("No entries logged."));
        } else {
            t = top - 2;
            p = -1;
            draw_set_font(fnt_40k_14);
            draw_set_alpha(0.8);
            repeat(25) {
                t++;
                p++;
                if (t >= ent) {
                    break;
                }
                cur_event = event[t];
                if (cur_event.text != "") { // 1554
                    draw_set_color(38144);
                    if (cur_event.colour = "red") {
                        draw_set_color(c_red);
                    }
                    if (cur_event.colour = "purple") {
                        draw_set_color(c_purple);
                    }
                    draw_text_ext(xx + 25, yy + 120 + (p * 26), $"{cur_event.date}  (Turn {cur_event.turn}) - {cur_event.text}", -1, 1554);
                    if (cur_event.event_target != "none") {
                        if (point_and_click(draw_unit_buttons([xx + 1400, yy + 120 + (p * 26)], "view", [1, 1], c_green, , fnt_40k_14b, 1))) {
                            var view_star = star_by_name(cur_event.event_target);
                            if (view_star != "none") {
                                obj_controller.menu = 0;
                                obj_controller.hide_banner = 0;
                                obj_controller.x = view_star.x;
                                obj_controller.y = view_star.y;
                            }
                        }
                    }
                }
            }
        }
        var x1, y1, x2, y2, scrolly, chunk_size, my, y5;
        x1 = xx + 1557;
        y1 = yy + 117;
        x2 = xx + 1583;
        y2 = yy + 823;
        draw_rectangle(x1, y1, x2, y2, 1);
        cubey = 30;
        scrolly = (y2 - y1) + 12; // The maximum amount of moving around that the cube does
        my = max(1, ent - 24); // The maximum number of scroll chunks
        chunk_size = scrolly / (my);
        y5 = (top - 1) * chunk_size;
        draw_rectangle(x1, y1 + y5, x2, y1 + y5 + cubey, 0);
    }
    draw_set_alpha(1);
}

if (help == 1) {
    draw_help_panel();
}