function calculate_research_points(turn_end=false){
    with (obj_controller){
        research_points = 0;
        forge_points = 0;
        master_craft_chance = 0;
        if (tech_status == "heretics") then master_craft_chance+=5;
        forge_string = $"Forge Production Rate#";
        var heretics = [], forge_master=-1, notice_heresy=false, forge_point_gen=[], crafters=0, at_forge=0, gen_data={};
        var tech_locations=[]
        var techs = collect_role_group("forge");
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
        forge_string += $"Techmarines: +{floor(forge_points)}#";
        var used_points = apothecary_simple(turn_end);
        forge_string += $"Vehicle Repairs: -{floor(used_points)}#";
        forge_points-=used_points;        
        var forge_veh_maintenance={};
        for (var comp=0;comp<=10;comp++){
            for (var veh=0;veh<=100;veh++){
                if (obj_ini.veh_role[comp][veh]=="Land Raider"){
                    forge_veh_maintenance.land_raider = struct_exists(forge_veh_maintenance, "land_raider") ?forge_veh_maintenance.land_raider + 1 : 1;
                } else if (array_contains(["Rhino","Predator", "Whirlwind"],obj_ini.veh_role[comp][veh])){
                    forge_veh_maintenance.small_vehicles = struct_exists(forge_veh_maintenance, "small_vehicles") ?forge_veh_maintenance.small_vehicles + 0.2 :0.2;
                }
            }
        }

        if (struct_exists(forge_veh_maintenance, "land_raider")){
            forge_string += $"Land Raider Maintenance: -{forge_veh_maintenance.land_raider}#";
            forge_points-=forge_veh_maintenance.land_raider;
        }
        if (struct_exists(forge_veh_maintenance, "small_vehicles")){
            if (floor(forge_veh_maintenance.small_vehicles)>0){
                forge_string += $"Small Vehicle Maintenance: -{floor(forge_veh_maintenance.small_vehicles)}#";
                forge_points-=floor(forge_veh_maintenance.small_vehicles);
            }
        }
        if (player_forge_data.player_forges>0){
            forge_points += 5*player_forge_data.player_forges;
            forge_string += $"Forges: +{5*player_forge_data.player_forges}#";
        }
        forge_points = floor(forge_points);
        var tech_test, charisma_test, piety_test, met_non_heretic, heretics_pursuade_chances, new_pursuasion;
        //in this instance tech heretics are techmarines with the "tech_heretic" trait
        if (turn_end){
            if (array_length(techs)==0) then scr_loyalty("Upset Machine Spirits","+");
            if (array_length(heretics)>0 && turn>75){
                var heretic_location, same_location, current_heretic, current_tech;
                //iterate through tech heretics;
                for (var heretic=0; heretic<array_length(heretics); heretic++){
                    heretic_location = tech_locations[heretics[heretic]];
                    current_heretic = techs[heretics[heretic]];
                    if (current_heretic.in_jail()) then continue;
                    heretics_pursuade_chances = (floor(current_heretic.charisma/5) - 3)
                    //iterate through rest of techs
                    pursuasions =[];
                    met_non_heretic = false;
                    for (var i=0; i<array_length(techs) && heretics_pursuade_chances>0; i++){
                        same_location=false;
                        new_pursuasion = irandom(array_length(techs)-1);
                        //if tech is also heretic skip
                        if (array_contains(heretics,new_pursuasion)) then continue;
                        if (array_contains(pursuasions,new_pursuasion)) then continue;
                        heretics_pursuade_chances--;
                        current_tech = techs[new_pursuasion];

                        // find out if heretic is in same location as techmarine
                        if (same_locations(heretic_location,tech_locations[new_pursuasion])){
                            met_non_heretic=true;
                            //if so do a an opposed technology test of techmarine vs tech  heretic techmarine
                            tech_test = global.character_tester.oppposed_test(current_heretic,current_tech, "technology");


                            if (tech_test[0]==1){
                                // if heretic wins do an opposed charisma test
                                charisma_test =  global.character_tester.oppposed_test(current_heretic,current_tech, "charisma", -15+current_tech.corruption);                           
                                if (charisma_test[0]==1){
                                    // if heretic win tech is corrupted
                                    //tech is corrupted by half the pass margin of the heretic
                                    //this means high charisma heretics will spread corruption more quickly and more often
                                    if (current_heretic.corruption>current_tech.corruption){
                                        current_tech.edit_corruption(min(4,charisma_test[1]));
                                    }

                                    // tech takes a piety test to see if tehy break faith with cult mechanicus and become tech heretic
                                    //piety test is augmented by by the techs corruption with the test becoming harder to pass the more
                                    // corrupted the tech is
                                    piety_test = global.character_tester.standard_test(current_tech, "piety", +75 - current_tech.corruption);

                                    // if tech fails piety test tech also becomes tech heretic
                                    if (piety_test[0] == false && choose(true,false)){
                                        current_tech.add_trait("tech_heretic");
                                    }
                                } else if (charisma_test[0]==2){
                                    if (charisma_test[1] > 40 && notice_heresy=false){
                                        scr_alert("purple","Tech Heresy",$"{current_tech.name_role()} contacts you concerned of Tech Heresy in the Armentarium");
                                        notice_heresy=true;
                                    }
                                }
                            }
                            if (new_pursuasion==forge_master){
                                // if tech is the forge master then forge master takes a wisdom in this case doubling as a perception test
                                // if forge master passes tech heresy is noted and chapter master notified
                                if (global.character_tester.standard_test(current_tech, "wisdom", - 40)[0] && !notice_heresy){
                                    notice_heresy=true;
                                    scr_event_log("purple",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                    scr_alert("purple","Tech Heresy",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                    //pip=instance_create(0,0,obj_popup);
                                }
                            }
                        }
                    }
                    if (!met_non_heretic){
                        if (irandom(4)==0){
                            current_heretic.edit_corruption(1);
                        }
                    }
                    //add check to see if tech heretic is anywhere near mechanicus forge if so maybe do stuff??
                    /*if (heretic_location==location_types.planet){
                        if 
                    }*/
                }
                if (array_length(techs)>array_length(heretics)){
                    if (array_length(heretics)/array_length(techs)>=0.35){
                        if (irandom(9)==0){
                            /*var text_string = "You Recive an Urgent Transmision from";
                            if (forge_master>-1){
    
                            }*/
                            scr_popup("Technical Differences!","You Recive an Urgent Transmision A serious breakdown in culture has coccured causing believers in tech heresy to demand that they are given preseidence and assurance to continue their practises","tech_uprising","");
                        }
                    }
                }
            }
            possibility_of_heresy = 8;
            if (scr_has_disadv("Tech-Heresy")) then possibility_of_heresy = 6;
            if (irandom(power(possibility_of_heresy,(array_length(heretics)+2.2))) == 0 && array_length(techs)>0){
                var current_tech = techs[irandom(array_length(techs)-1)];
               if  (!global.character_tester.standard_test(current_tech, "piety")[0]){
                   current_tech.add_trait("tech_heretic");
                   current_tech.edit_corruption(20+irandom(15));
               }
            }
            if (forge_master==-1){ 
                var tech_count = scr_role_count(obj_ini.role[100][16]);
                if (tech_count>1){
                    var last_master = obj_ini.previous_forge_masters[array_length(obj_ini.previous_forge_masters)-1];
                    scr_popup("New Forge Master",$"The Demise of Forge Master {last_master} means a replacement must be chosen. Several Options have already been put forward to you but it is ultimatly your decision.","new_forge_master","");
                } else if (tech_count==1){
                    scr_role_count(obj_ini.role[100][16],"","units")[0].update_role("Forge Master");
                }
            }
            forge_queue_logic();       
        }
    }   
}
function scr_forge_item(item){
    var master_craft_count=0;
    var quality_string="";
    var normal_count=0;
    for (var s=0;s<item.count;s++){
        if (master_craft_chance && (irandom(100)<master_craft_chance)){
            master_craft_count++;
        } else {
            normal_count++;
        }
    }
    scr_add_item(item.name, normal_count);
    if (master_craft_count>0){
        scr_add_item(item.name, master_craft_count,"master_crafted");
        var numerical_string = master_craft_count==1?"was":"were";
        quality_string=$"X{master_craft_count} {numerical_string} Completed to a Master Crafted standard";
    }else {
        quality_string=$"all were completed to a standard STC compliant quality";
    }
    scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished {quality_string}","","");
}

function scr_advance_research(research){
    if (research.name[0]=="research"){
        var tier_depth = array_length(research.name[2]);
        var tier_names=research.name[2];
        if (tier_depth==1){
            production_research[$ tier_names[0]][0]++;
        } else if (tier_depth==2){
            production_research[$ tier_names[0]][1][$ tier_names[1]][0]++;
        } else if (tier_depth == 3){
            production_research[$ tier_names[0]][1][$ tier_names[1]][1][$ tier_names[2]][0]++;
        }
    }    
}

function scr_evaluate_forge_item_completion(item){
    if (is_string(item.name)){
        var vehicles = ["Rhino","Predator","Land Raider","Whirlwind","Land Speeder"];
        var is_vehicle =  array_contains(vehicles,item.name);
        if (!is_vehicle){
            scr_forge_item(item);
        } else {
            repeat(item.count){
                var vehicle = scr_add_vehicle(item.name,9,"standard","standard","standard","standard","standard");
                var build_loc = array_random(player_forge_data.vehicle_hanger);
                obj_ini.veh_loc[vehicle[0]][vehicle[1]] = build_loc[0];
                obj_ini.veh_wid[vehicle[0]][vehicle[1]] = build_loc[1];
                obj_ini.veh_lid[vehicle[0]][vehicle[1]] = -1;
            }
            scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished Vehicles Waiting at hanger on {build_loc[0]} {build_loc[1]}","","");
        }                      
    } else if (is_array(item.name)){
        scr_advance_research(item);
    }
}
function forge_queue_logic(){
    if (forge_points>0){
        var reduction_points = forge_points;
        if (array_length(forge_queue)>0 && forge_points>0){
            var forging_length = array_length(forge_queue);
            for (var i=0;i<forging_length;i++){
                if (forge_queue[i].forge_points<=reduction_points){
                    reduction_points-=forge_queue[i].forge_points;

                    scr_evaluate_forge_item_completion(forge_queue[i]);

                    array_delete(forge_queue, i, 1);
                    i--;
                    forging_length--;
                } else {
                    forge_queue[i].forge_points -= reduction_points;
                    reduction_points=0;
                }
                if (reduction_points<=0) then break;
            }
        }
    } 
}
function research_end(){
    calculate_research_points(true);
    stc_research[$ stc_research.research_focus] += research_points;
    var research_area_limit;
    if (stc_research.research_focus=="vehicles"){
        research_area_limit = stc_vehicles;
    } else if (stc_research.research_focus=="wargear"){
        research_area_limit = stc_wargear;
    }else if (stc_research.research_focus=="ships"){
        research_area_limit = stc_ships;
    }    
    if (stc_research[$ stc_research.research_focus]>5000*(research_area_limit+1)){
       identify_stc(stc_research.research_focus);  
    }
}