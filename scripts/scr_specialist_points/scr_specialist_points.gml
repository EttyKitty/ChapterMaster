

function SpecialistPointHandler() constructor{

    static chapter_spread = calculate_full_chapter_spread;
    static healing_and_point_use = apothecary_simple;
    forge_queue = [];
    techs = [];
    forge_master=-1;
    master_craft_chance = 0;
    static calculate_research_points = function(turn_end=false){
        self.turn_end=turn_end;
        research_points = 0;
        forge_points = 0;
        master_craft_chance = 0;
        apoth_points_used = 0;
        tech_points_used = 0;
        crafters=0;
        at_forge = 0;

        if (obj_controller.tech_status == "heretics") then master_craft_chance+=5;

        techs = [];
        heretics = [];

        forge_string = $"Forge Production Rate#";
        forge_master=-1;
        healing_and_point_use(turn_end);
        var _noticed_heresy=false, at_forge=0;
        var _tech_locations=[]
        var _cur_tech;
        total_techs = array_length(techs);
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
            _tech_locations[i] = techs[i].marine_location();
        }
        if (forge_master>-1){
            obj_controller.master_of_forge = techs[forge_master];
        }
        forge_string += $"Techmarines: +{floor(forge_points)}#";
        forge_string += $"Vehicle Repairs: -{floor(tech_points_used)}#";
        forge_points-=tech_points_used;        
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
        var _forge_data = obj_controller.player_forge_data;
        if (_forge_data.player_forges>0){
            forge_points += 5*_forge_data.player_forges;
            forge_string += $"Forges: +{5*_forge_data.player_forges}#";
        }
        forge_points = floor(forge_points);
        //in this instance tech heretics are techmarines with the "tech_heretic" trait
        if (turn_end){
            if (array_length(techs)==0) then scr_loyalty("Upset Machine Spirits","+");

            tech_ideology_spread();
            new_tech_heretic_spawn();

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
        obj_controller.research_points = 0;
        obj_controller.forge_points = 0;
        obj_controller.master_craft_chance = 0;
        obj_controller.forge_string = forge_string;
    }

    static new_tech_heretic_spawn = function(){
        var _possibility_of_heresy = 8;
        if (array_contains(obj_ini.dis,"Tech-Heresy")) then _possibility_of_heresy = 6;
        if (irandom(power(_possibility_of_heresy,(array_length(heretics)+2.2))) == 0 && array_length(techs)>0){
            var _current_tech = array_random_element(techs);
           if  (!global.character_tester.standard_test(_current_tech, "piety")[0]){
               _current_tech.add_trait("tech_heretic");
               _current_tech.edit_corruption(20+irandom(15));
           }
        }
    }

    static add_forge_points_to_stack = function(unit){
        array_push(techs, unit);
        if (unit.technology>40 && unit.hp() > 0){
            var _cur_tech = unit
            research_points += _cur_tech.technology-40;
            var _forge_point_gen=_cur_tech.forge_point_generation(true);
            var _unit_forge_gen_data = _forge_point_gen[1];
            if (struct_exists(_unit_forge_gen_data,"crafter")) then crafters++;
            if (struct_exists(_unit_forge_gen_data,"at_forge")){
                at_forge++;
                master_craft_chance += (unit.experience()/50);
            }
            forge_points += _forge_point_gen[0];
            if (unit.has_trait("tech_heretic")){
                array_push(heretics, array_length(techs)-1);
            }
        }
    }

    static tech_ideology_spread = function(){
        var tech_test, charisma_test, piety_test, met_non_heretic, heretics_pursuade_chances, new_pursuasion;
        if (array_length(heretics)>0 && turn>75){
            var _heretic_location, _same_location, _current_heretic, _current_tech;
            //iterate through tech heretics;
            for (var heretic=0; heretic<array_length(heretics); heretic++){
                _heretic_location = _tech_locations[heretics[heretic]];
                _current_heretic = techs[heretics[heretic]];
                if (_current_heretic.in_jail()) then continue;
                heretics_pursuade_chances = (floor(_current_heretic.charisma/5) - 3)
                //iterate through rest of techs
                pursuasions =[];
                met_non_heretic = false;
                for (var i=0; i<array_length(techs) && heretics_pursuade_chances>0; i++){
                    _same_location=false;
                    new_pursuasion = irandom(array_length(techs)-1);
                    //if tech is also heretic skip
                    if (array_contains(heretics,new_pursuasion)) then continue;
                    if (array_contains(pursuasions,new_pursuasion)) then continue;
                    heretics_pursuade_chances--;
                    _current_tech = techs[new_pursuasion];

                    // find out if heretic is in same location as techmarine
                    if (same_locations(_heretic_location,_tech_locations[new_pursuasion])){
                        met_non_heretic=true;
                        //if so do a an opposed technology test of techmarine vs tech  heretic techmarine
                        tech_test = global.character_tester.oppposed_test(_current_heretic,_current_tech, "technology");


                        if (tech_test[0]==1){
                            // if heretic wins do an opposed charisma test
                            charisma_test =  global.character_tester.oppposed_test(_current_heretic,_current_tech, "charisma", -15+_current_tech.corruption);                           
                            if (charisma_test[0]==1){
                                // if heretic win tech is corrupted
                                //tech is corrupted by half the pass margin of the heretic
                                //this means high charisma heretics will spread corruption more quickly and more often
                                if (_current_heretic.corruption>_current_tech.corruption){
                                    _current_tech.edit_corruption(min(4,charisma_test[1]));
                                }

                                // tech takes a piety test to see if they break faith with cult mechanicus and become tech heretic
                                //piety test is augmented by by the techs corruption with the test becoming harder to pass the more
                                // corrupted the tech is
                                piety_test = global.character_tester.standard_test(_current_tech, "piety", +75 - _current_tech.corruption);

                                // if tech fails piety test tech also becomes tech heretic
                                if (piety_test[0] == false && choose(true,false)){
                                    _current_tech.add_trait("tech_heretic");
                                }
                            } else if (charisma_test[0]==2){
                                if (charisma_test[1] > 40 && _noticed_heresy=false){
                                    scr_alert("purple","Tech Heresy",$"{_current_tech.name_role()} contacts you concerned of Tech Heresy in the Armentarium");
                                    _noticed_heresy=true;
                                }
                            }
                        }
                        if (new_pursuasion==forge_master){
                            // if tech is the forge master then forge master takes a wisdom in this case doubling as a perception test
                            // if forge master passes tech heresy is noted and chapter master notified
                            if (global.character_tester.standard_test(_current_tech, "wisdom", - 40)[0] && !_noticed_heresy){
                                _noticed_heresy=true;
                                scr_event_log("purple",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                scr_alert("purple","Tech Heresy",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                //pip=instance_create(0,0,obj_popup);
                            }
                        }
                    }
                }
                if (!met_non_heretic){
                    if (irandom(4)==0){
                        _current_heretic.edit_corruption(1);
                    }
                }
                //add check to see if tech heretic is anywhere near mechanicus forge if so maybe do stuff??
                /*if (_heretic_location==location_types.planet){
                    if 
                }*/
            }
            if (array_length(techs)>array_length(heretics)){
                if (array_length(heretics)/array_length(techs)>=0.35){
                    if (!irandom(9)){
                        /*var text_string = "You Recive an Urgent Transmision from";
                        if (forge_master>-1){

                        }*/
                        scr_popup("Technical Differences!","You Recive an Urgent Transmision A serious breakdown in culture has coccured causing believers in tech heresy to demand that they are given preseidence and assurance to continue their practises","tech_uprising","");
                    }
                }
            }
        }   
    }


    static forge_queue_logic = function(){
        if (forge_points>0){
            var _reduction_points = forge_points;
            if (array_length(forge_queue)>0 && forge_points>0){
                var forging_length = array_length(forge_queue);
                for (var i=0;i<forging_length;i++){
                    if (forge_queue[i].forge_points<=_reduction_points){
                        _reduction_points-=forge_queue[i].forge_points;

                        scr_evaluate_forge_item_completion(forge_queue[i]);

                        array_delete(forge_queue, i, 1);
                        i--;
                        forging_length--;
                    } else {
                        forge_queue[i].forge_points -= _reduction_points;
                        _reduction_points=0;
                    }
                    if (_reduction_points<=0) then break;
                }
            }
        } 
    }

    static draw_forge_queue = function(xx,yy){
        var _box_width = 527;
        draw_set_color(c_gray);
        draw_rectangle(xx, yy , xx + _box_width, yy + 50, 0);
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);
        draw_set_color(0);
        draw_text(xx,yy,"Name");
        draw_text(xx+141,yy,"Number");
        draw_text(xx+241,yy,"Forge Points");
        draw_text(xx+341,yy,"Construction ETA");        
        draw_set_color(c_gray);
        var item_gap = 13;
        var total_eta=0;        
        static top_point=0;
        for (var i=top_point; i<13; i++){
            if (i+1>array_length(forge_queue)) then break;
            draw_set_color(c_gray);
            if scr_hit(xx,yy+item_gap,xx+_box_width,yy+item_gap+20){
                draw_set_color(c_white)
            }
            if (is_string(forge_queue[i].name)){
                draw_text(xx,yy + item_gap,string_hash_to_newline(forge_queue[i].name));
                draw_text(xx+166,yy + item_gap,forge_queue[i].count);
                if (forge_queue[i].ordered==obj_controller.turn){
                    if (forge_queue[i].count>1){
                        if (point_and_click(draw_unit_buttons([xx+141 , yy + item_gap],"-",[0.75,0.75],c_red))){
                            var unit_cost = forge_queue[i].forge_points/forge_queue[i].count;
                            forge_queue[i].count--;
                            forge_queue[i].forge_points-=unit_cost;
                        }               
                    }
                    if (forge_queue[i].count<100){
                        if (point_and_click(draw_unit_buttons([xx+545 , yy + item_gap],"+",[0.75,0.75],c_green))){
                            var unit_cost = forge_queue[i].forge_points/forge_queue[i].count;
                            forge_queue[i].count++;
                            forge_queue[i].forge_points+=unit_cost;
                        }                 
                    }
                }
            } else if (is_array(forge_queue[i].name)){
                if (forge_queue[i].name[0]  == "research"){
                    draw_text(xx+359,yy + item_gap,forge_queue[i].name[1]);
                }
            }
            draw_text(xx+271,yy + item_gap,string_hash_to_newline(forge_queue[i].forge_points));
            total_eta += ceil(forge_queue[i].forge_points/forge_points);
            draw_text(xx+376,yy+ item_gap,$"{total_eta} turns");        
            if (point_and_click(draw_unit_buttons([xx+491, yy + item_gap],"X",[0.75,0.75],c_red))){
                array_delete(forge_queue, i, 1);
            }                    
            item_gap +=20
        }        
    }
    static scr_forge_item = function(item){
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
    static scr_evaluate_forge_item_completion = function(item){
        if (is_string(item.name)){
            var _vehicles = ["Rhino","Predator","Land Raider","Whirlwind","Land Speeder"];
            var is_vehicle =  array_contains(_vehicles,item.name);
            if (!is_vehicle){
                scr_forge_item(item);
            } else {
                repeat(item.count){
                    var vehicle = scr_add_vehicle(item.name,9,"standard","standard","standard","standard","standard");
                    var build_loc = array_random(obj_controller.player_forge_data.vehicle_hanger);
                    obj_ini.veh_loc[vehicle[0]][vehicle[1]] = build_loc[0];
                    obj_ini.veh_wid[vehicle[0]][vehicle[1]] = build_loc[1];
                    obj_ini.veh_lid[vehicle[0]][vehicle[1]] = 0;
                }
                scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished Vehicles Waiting at hanger on {build_loc[0]} {build_loc[1]}","","");
            }                      
        } else if (is_array(item.name)){
            scr_advance_research(item);
        }
    }
    /*static apothecary_points_calc(){

    }*/
}


function unit_forge_point_generation(turn_end=false){
    var trained_person = IsSpecialist("forge");
    var crafter = has_trait("crafter");
    if (!(trained_person || crafter)) then return 0;
    var reasons = {}
    var points = 0;
    if (trained_person){
        var points = technology / 5;
        reasons.trained = points;
    }
    if (job!="none"){
        if (job.type == "forge"){
            
            if (crafter){
                points*=3;
                reasons.at_forge = "x3 (Crafter)";
            } else {
                points*=2;
                reasons.at_forge = "x2";
            }
            points+=6;
            if (turn_end){
                add_exp(0.2);
            }
        }
    }
    if (crafter){
        points+=6;
        reasons.crafter = 6;
    }
    if (role()=="Forge Master"){
        points+=10;
        reasons.master = 10;
    }
    var maintenance = equipment_maintenance_burden();
    points -= maintenance;
    reasons.maintenance = $"-{maintenance}";
    return [points,reasons];
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

function research_end(){
    specialist_point_handler.calculate_research_points(true);
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


function unit_apothecary_point_generation(){

}

function apothecary_points_calc(){
    with (obj_controller){
        research_points = 0;
        apoth_points = 0;
        var heretics = [], forge_master=-1, _noticed_heresy=false, _forge_point_gen=[], crafters=0, at_forge=0, _unit_forge_gen_data={};
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
                _forge_point_gen=techs[i].forge_point_generation(true);
                _unit_forge_gen_data = _forge_point_gen[1];
                if (struct_exists(_unit_forge_gen_data,"crafter")) then crafters++;
                if (struct_exists(_unit_forge_gen_data,"at_forge")){
                    at_forge++;
                    master_craft_chance += (techs[i].experience()/50)
                }
                forge_points += _forge_point_gen[0];
                if (techs[i].has_trait("tech_heretic")){
                    array_push(heretics, i);
                }
            }
            _tech_locations[i] = techs[i].marine_location();
        }
        if (forge_master>-1){
            obj_controller.master_of_forge = techs[forge_master];
        }
    }
}
