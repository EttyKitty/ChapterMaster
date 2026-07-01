if ((enemy_forces != 0) && (player_forces != 0) && (battle_over == 0)) {
    if ((enemy == 6) && (timer_stage == 2)) {
        timer_stage = 3;
    }

    if ((enemy != 6) && (timer_stage == 2)) {
        timer_stage = 3;
    }

    if ((enemy == 6) && (timer_stage == 4)) {
        timer_stage = 5;
    }

    if ((enemy != 6) && (timer_stage == 4)) {
        timer_stage = 5;
    }
}
