// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function apothecary_points_calc(){
	with (obj_controller){
        research_points = 0;
        apoth_points = 0;
        var heretics = [], forge_master=-1, notice_heresy=false, forge_point_gen=[], crafters=0, at_forge=0, gen_data={};
        var apoth_locations=[]
        var apoths = collect_role_group("forge");
        var total_techs = array_length(techs);
        for (var i=0; i<array_length(techs); i++){
            if (techs[i].IsSpecialist("heads")){
                forge_master=i;
            }            
            if (techs[i].in_jail()){
                array_delete(techs, i, 1);
                i--;
                total_techs--;
                continue;
            }
            if (techs[i].technology>40 && techs[i].hp() >0){
                research_points += techs[i].technology-40;
                forge_point_gen=techs[i].forge_point_generation(true);
                gen_data = forge_point_gen[1];
                if (struct_exists(gen_data,"crafter")) then crafters++;
                if (struct_exists(gen_data,"at_forge")){
                    at_forge++;
                    master_craft_chance += (techs[i].experience()/50)
                }
                forge_points += forge_point_gen[0];
                if (techs[i].has_trait("tech_heretic")){
                    array_push(heretics, i);
                }
            }
            tech_locations[i] = techs[i].marine_location();
        }
        if (forge_master>-1){
            obj_controller.master_of_forge = techs[forge_master];
        }
    }
}


function scr_apothecarium(){
	draw_sprite(spr_rock_bg, 0, xx, yy);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
    draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

    if (menu_adept = 0) {
        scr_image("advisor", 1, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,1,xx+16,yy+43);
        if (global.chapter_name = "Space Wolves") then scr_image("advisor", 11, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,11,xx+16,yy+43);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, "Apothecarium", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, "Master of the Apothecarion " + string(obj_ini.name[0, 4]), 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }
    if (menu_adept = 1) {
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        scr_image("advisor", 0, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 40, string_hash_to_newline("Apothecarium"), 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }

    blurp = "Milord, I come with a report.  Our Chapter currently boasts " + string(temp[36]) + " " + string(obj_ini.role[100, 15]) + " working on a variety of things, from field-duty to research to administrative duties.  ";

    if (training_apothecary = 0) then blurp += "Our Brothers are currently not assigned to train further " + string(obj_ini.role[100, 15]) + "; no more can be trained until Apothcarium funds are increased.";
    //
    if (training_apothecary > 0) then blurp += "Our Brothers assigned to the training of future " + string(obj_ini.role[100, 15]) + "s have taken up a ";
    if (training_apothecary >= 1 && training_apothecary <= 6) then blurp += recruitment_rates[training_apothecary - 1];
    if (training_apothecary > 0) then blurp += " pace and expect to graduate an additional " + string(obj_ini.role[100, 15]) + " in ";
    // 
    if (training_apothecary = 1) then eta = floor((47 - apothecary_points) / 0.8) + 1;
    if (training_apothecary = 2) then eta = floor((47 - apothecary_points) / 0.9) + 1;
    if (training_apothecary = 3) then eta = floor((47 - apothecary_points) / 1) + 1;
    if (training_apothecary = 4) then eta = floor((47 - apothecary_points) / 1.5) + 1;
    if (training_apothecary = 5) then eta = floor((47 - apothecary_points) / 2) + 1;
    if (training_apothecary = 6) then eta = floor((47 - apothecary_points) / 4) + 1;
    // 
    if (training_apothecary > 0) then blurp += string(eta) + " months.";

    if (gene_seed <= 0) then blurp += "##My lord, our stocks of gene-seed are empty.  It would be best to have some come mechanicus tithe.##Further training of Neophytes is halted until our stocks replenish.";
    if (gene_seed > 0) and(gene_seed <= 10) then blurp += "##My Brother " + string(obj_ini.role[100, 15]) + "s assigned to the gene-vault have informed me that our stocks are nearly gone.  They only number " + string(gene_seed) + "; this includes those recently recovered from our fallen comerades-in-arms.";
    if (gene_seed > 10) then blurp += "##My Brother " + string(obj_ini.role[100, 15]) + "s assigned to the gene-vault have informed me that our stocks of gene-seed currently number " + string(gene_seed) + ".  This includes those recently recovered from our fallen comerades-in-arms.";
    if (gene_seed > 0) then blurp += "##The stocks are stable and show no sign of mutation.";

    if (menu_adept = 1) {
        blurp = "Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100, 15]) + ".##";
        blurp += "Training of further " + string(obj_ini.role[100, 15]) + "s";
        if (training_apothecary >= 0 && training_apothecary <= 6) then blurp += recruitment_pace[training_apothecary];
        if (training_apothecary > 0) then blurp += "  The next " + string(obj_ini.role[100, 15]) + " is expected in " + string(eta) + " months.";
        blurp += "##You have " + string(gene_seed) + " gene-seed stocked.";
    }

    draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

    var blurp2 = "";

    if (obj_ini.zygote = 0) {
        if (obj_controller.marines + obj_controller.gene_seed <= 300) and(obj_ini.slave_batch_num[1] = 0) {
            blurp2 = "Our Chapter is disasterously low in number- it is strongly advised that we make use of test-slaves to breed new gene-seed.  Give me the word andwe can begin installing gestation pods.";
        }
        if (obj_controller.marines + obj_controller.gene_seed > 300) and(obj_ini.slave_batch_num[1] = 0) {
            blurp2 = "Our Chapter is capable of using test-slaves to breed new gene-seed.  Should our number of astartes ever plummet this may prove a valuable method of rapidly bringing our chapter back up to size.";
        }
        if (obj_ini.slave_batch_num[1] > 0) {
            blurp2 = "Our Test-Slave Incubators are working optimally.  As soon as a batch fully matures a second progenoid gland they will be harvested and prepared for use.";
        }
    }
    if (obj_ini.zygote = 1) then blurp2 = "Unfortunantly we cannot make use of Test-Slave Incubators.  Due to our missing Zygote any use of gestation pods is ultimately useless- no new gene-seed may be grown, no matter how long we wait.";

    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(xx + 622, yy + 440, string_hash_to_newline("Test-Slave Incubators"), 0.6, 0.6, 0);
    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_14);
    draw_text_ext(xx + 336 + 16, yy + 477, string_hash_to_newline(string(blurp2)), -1, 536);

    var currently_rendered_slave_index = 0;
    for (var i = 1; i <= 120; i++) { // TODO why go through all batches if we can only display 10?
        if (obj_ini.slave_batch_num[i] > 0 && currently_rendered_slave_index < 10) {
            currently_rendered_slave_index++;
            draw_text(xx + 336 + 16, yy + 513 + (currently_rendered_slave_index * 20), string_hash_to_newline("Batch " + string(currently_rendered_slave_index)));
            draw_text(xx + 336 + 16.5, yy + 513.5 + (currently_rendered_slave_index * 20), string_hash_to_newline("Batch " + string(currently_rendered_slave_index)));
            draw_text(xx + 536, yy + 513 + (currently_rendered_slave_index * 20), string_hash_to_newline("Eta: " + string(obj_ini.slave_batch_eta[currently_rendered_slave_index]) + " months"));
            draw_text(xx + 756, yy + 513 + (currently_rendered_slave_index * 20), string_hash_to_newline(string(obj_ini.slave_batch_num[currently_rendered_slave_index]) + " pods"));
        }
    }
    draw_set_alpha(1);
    if (obj_controller.gene_seed <= 0) or(obj_ini.zygote = 1) then draw_set_alpha(0.5);
    draw_set_color(c_gray);
    draw_rectangle(xx + 407, yy + 788, xx + 529, yy + 811, 0);
    draw_set_color(c_black);
    draw_text(xx + 411, yy + 793, string_hash_to_newline("Add Test-Slave"));
    if (obj_controller.gene_seed > 0) and(mouse_x >= xx + 407) and(mouse_y >= yy + 788) and(mouse_x < xx + 529) and(mouse_y < yy + 811) {
        draw_set_alpha(0.2);
        draw_set_color(c_gray);
        draw_rectangle(xx + 407, yy + 788, xx + 529, yy + 811, 0);
    }
    draw_set_alpha(1);
    if (obj_ini.slave_batch_num[1] <= 0) then draw_set_alpha(0.5);
    draw_set_color(c_gray);
    draw_rectangle(xx + 659, yy + 788, xx + 838, yy + 811, 0);
    draw_set_color(c_black);
    draw_text(xx + 664, yy + 793, string_hash_to_newline("Destroy All Incubators"));
    if (obj_ini.slave_batch_num[1] > 0) and(mouse_x >= xx + 659) and(mouse_y >= yy + 788) and(mouse_x < xx + 838) and(mouse_y < yy + 811) {
        draw_set_alpha(0.2);
        draw_set_color(c_gray);
        draw_rectangle(xx + 659, yy + 788, xx + 838, yy + 811, 0);
    }
    draw_set_alpha(1);
}