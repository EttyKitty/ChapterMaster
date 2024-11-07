


function calculate_full_chapter_spread(){
 	obj_controller.command=0;
 	obj_controller.marines=0;	
	var _mar_loc,is_healer,_is_tech,key_val,veh_location,array_slot,_unit;
	var _tech_spread = {};
	var _apoth_spread = {};
	var _unit_spread = {};
    for(var company=0;company<11;company++){
    	for (var v=0; v < array_length(obj_ini.name[company]); v++) {
    		key_val = "";
    		if (obj_ini.name[company][v]=="") then continue;
    		_unit = fetch_unit([company, v]);
    		_mar_loc = _unit.marine_location();
    		if (_unit.base_group=="astartes"){
	    		if (_unit.IsSpecialist()){
	    			obj_controller.command++;
	    		} else {
	    			obj_controller.marines++;
	    		}
	    	}
	        tech_points_used += _unit.equipment_maintenance_burden();
		    _is_tech = (_unit.IsSpecialist("forge") && _unit.hp()>=10);
		    if (_is_tech){
		    	add_forge_points_to_stack(_unit);
		    }
		    is_healer = (((_unit.IsSpecialist("apoth",true) && _unit.gear()=="Narthecium") || (_unit.role()=="Sister Hospitaler")) && _unit.hp()>=10);
		  	if (_mar_loc[2]!="warp"){
  	    		if (_mar_loc[0]=location_types.planet){
  	    			array_slot = _mar_loc[1];
  	    		} else if (_mar_loc[0] == location_types.ship){
  	    			array_slot=0;
  	    		}
  	    		key_val = _mar_loc[2];
  	    	} else if (_mar_loc[0] == location_types.ship){
  	    		if instance_exists(obj_p_fleet){
  	    			with (obj_p_fleet){
  	    				if (array_contains(capital_num, _mar_loc[1]) ||
  	    					array_contains(frigate_num, _mar_loc[1])||
  	    					array_contains(escort_num, _mar_loc[1])
  	    				){
  	    					key_val=string(id);
  	    					array_slot=0;
  	    					break;
  	    				}
  	    			}
  	    		}
  	    	}
  	    	if (key_val!=""){
				if (! struct_exists(_unit_spread, key_val)){
					_unit_spread[$key_val] = [[],[],[],[],[]];
					_tech_spread[$key_val]  = [[],[],[],[],[]];
					_apoth_spread[$key_val]  = [[],[],[],[],[]];
				}
				array_push(_unit_spread[$key_val][array_slot] ,_unit);
				if (_is_tech){
					array_push(_tech_spread[$key_val][array_slot] ,_unit);
				}
				if (is_healer)	{
					array_push(_apoth_spread[$key_val][array_slot] ,_unit);
				}		
			}
			key_val="";
            if (v<array_length(obj_ini.veh_hp[company]) && company>0){
            	if (obj_ini.veh_race[company][v]!=0){
            		if(obj_ini.veh_lid[company][v]>0){
	            		veh_location = obj_ini.veh_lid[company][v];
	            		if (obj_ini.ship_location[veh_location] == "warp"){
			  	    		if instance_exists(obj_p_fleet){
			  	    			with (obj_p_fleet){
			  	    				if (array_contains(capital_num, veh_location) ||
			  	    					array_contains(frigate_num, veh_location)||
			  	    					array_contains(escort_num, veh_location)
			  	    				){
			  	    					key_val=string(id);
			  	    					array_slot=0;
			  	    					break;
			  	    				}
			  	    			}
			  	    		}
			  	    	} else if (obj_ini.ship_location[veh_location] != ""){
			  	    		array_slot=0;
			  	    		key_val=obj_ini.ship_location[veh_location];
			  	    	}
		            }            	
	            	if (obj_ini.veh_wid[company][v]>0){
	            		key_val = obj_ini.veh_loc[company][v];
	            		if (key_val!=""){
		            		array_slot = obj_ini.veh_wid[company][v];
						}     		
	            	}
	  	    		if (key_val!=""){
						if (! struct_exists(_unit_spread, key_val)){
							_unit_spread[$key_val] = [[],[],[],[],[]];
							_tech_spread[$key_val]  = [[],[],[],[],[]];
							_apoth_spread[$key_val]  = [[],[],[],[],[]];
						}
						array_push(_unit_spread[$key_val][array_slot] ,[company,v]);	  	    		
	            	}
	            }           	
            }			
	    }
	}
	return [_tech_spread,_apoth_spread,_unit_spread]	
}


function apothecary_simple(){
	var  _unit;
	var _spreads = chapter_spread();
	var _tech_spread = _spreads[0];
	var _apoth_spread = _spreads[1];
	var _unit_spread = _spreads[2];
	var apoth_points_used = 0;
	forge_string += $"Equipment Maintenance : -{tech_points_used}#";
    //marines-=1;

	var _locations = struct_get_names(_unit_spread);
	with (obj_star){
		for (var i=0;i<array_length(_locations);i++){
			if (_locations[i] == name){
				array_push(_unit_spread[$ _locations[i]], self)
			}
		}
	}
	var cur_units, cur_apoths, cur_techs, total_heal_points, veh_health, points_spent, cur_system, features;
	var total_bionics = scr_item_count("Bionics");
	for (i=0;i<array_length(_locations);i++){
		cur_system="";
		if (array_length(_unit_spread[$_locations[i]]) == 6){
			cur_system = _unit_spread[$_locations[i]][5];
		}		
		for (var p=0;p<5;p++){
			total_heal_points=0;
			forge_points=0;
			if (array_length(_unit_spread[$_locations[i]][p]) == 0) then continue;
			cur_units = _unit_spread[$_locations[i]][p];
			cur_apoths = _apoth_spread[$_locations[i]][p];
			cur_techs = _tech_spread[$_locations[i]][p];
			for (var a=0;a<array_length(cur_apoths);a++){
				_unit = cur_apoths[a];
				total_heal_points+=((_unit.technology/2)+(_unit.wisdom/2)+_unit.intelligence)/8;
			}
			for (var a=0;a<array_length(cur_techs);a++){
				_unit = cur_techs[a];
				forge_points += _unit.forge_point_generation(true)[0];
			}
			for (var a=0;a<array_length(cur_units);a++){
				points_spent = 0;
				_unit = cur_units[a];
				if (is_array(_unit) && forge_points>0){
					if (array_length(_unit)>1){
						while (points_spent<10 && obj_ini.veh_hp[_unit[0]][_unit[1]]<100 && forge_points>0){
							points_spent++;
							if (turn_end){
								obj_ini.veh_hp[_unit[0]][_unit[1]]++;
							}
							forge_points--;
							tech_points_used++;
						}
					}
				} else if (is_struct(_unit)){
					if  (_unit.hp() < _unit.max_health()){
						if (_unit.armour() != "Dreadnought"){
							if (_unit.hp()>0){
			        			if (total_heal_points >0){
			        				if (turn_end){
			        					_unit.healing(true);
			        				}
			        				total_heal_points--;
			        			} else {
			        				if (turn_end){
			        					_unit.healing(false);
			        				}
			        			}	
							} else if (total_heal_points>0 && forge_points>=3 && _unit.bionics<10){
								_unit.add_bionics();
								total_heal_points--;
								forge_points-=3;
								tech_points_used+=tech_points_used
							}			
						} else {
							if (total_heal_points>0 && forge_points>=3 && _unit.hp()>0){
		        				if (turn_end){
		        					_unit.healing(true);
		        				}
								total_heal_points--;
								forge_points-=3;
								tech_points_used+=3							
							}
						}
					}
				}
			}
			if (cur_system!="" && p>0 && turn_end){
				with (cur_system){
		 			if (array_length(p_feature[p])!=0){
			        	var engineer_count=array_length(cur_techs);
						if (planet_feature_bool(p_feature[p],P_features.Starship)==1 && engineer_count>0){
							//TODO allow total tech point usage here
			                var starship = p_feature[p][search_planet_features(p_feature[p],P_features.Starship)[0]];
			                var engineer_score_start = starship.engineer_score;
		                	if (starship.engineer_score<2000){
			                	for (var v=0;v<engineer_count;v++){
			                		starship.engineer_score += (cur_techs[v].technology/2);
			                	}
			                	scr_alert("green","owner",$"Ancient ship repairs {min((starship.engineer_score/2000)*100, 100)}% complete",x,y);
		                	}
		            
			                var maxr=0,requisition_spend=0,target_spend=10000;
		
			                maxr=floor(obj_controller.requisition/50);
			                requisition_spend=min(maxr*50,array_length(cur_techs)*50,target_spend-starship.funds_spent);
			                obj_controller.requisition-=requisition_spend;
			                starship.funds_spent+=requisition_spend;
		                
			                if (requisition_spend>0) and (starship.funds_spent<target_spend){
			                    scr_alert("green","owner",$"{requisition_spend} Requision spent on Ancient Ship repairs in materials and outfitting (outfitting {(starship.funds_spent/target_spend)*100}%)",x,y);
			                }
			                if (starship.funds_spent>=target_spend) and(starship.engineer_score>=2000){// u2=tar;
			                	//TODO refactor into general new ship logic
			                    delete_features(cur_system.p_feature[p],P_features.Starship);
		                    
			                    var locy=$"{name} {scr_roman_numerals()[p-1]}";
		                    
			                    var flit=instance_create(cur_system.x,cur_system.y,obj_p_fleet);
			                    var s=0,ship_names="",new_name="",last_ship=0;
			                    for(s=1;s<=40;s++){
			                        if (last_ship=0) and (obj_ini.ship[s]="") then last_ship=s;
			                    };
		                    
			                    new_name="Slaughtersong";
		                    	//TODO extract ot it's own area
			                    obj_ini.ship[last_ship]=new_name;
			                    obj_ini.ship_uid[last_ship]=floor(random(99999999))+1;
			                    obj_ini.ship_owner[last_ship]=1;
			                    obj_ini.ship_size[last_ship]=3;
			                    obj_ini.ship_location[last_ship]=name;
			                    obj_ini.ship_leadership[last_ship]=100;
		                    
			                    obj_ini.ship_class[last_ship]="Slaughtersong";
		                    
			                    obj_ini.ship_hp[last_ship]=2400;
			                    obj_ini.ship_maxhp[last_ship]=2400;
			                    obj_ini.ship_conditions[last_ship]="";
			                    obj_ini.ship_speed[last_ship]=25;
			                    obj_ini.ship_turning[last_ship]=60;
			                    obj_ini.ship_front_armour[last_ship]=8;
			                    obj_ini.ship_other_armour[last_ship]=8;
			                    obj_ini.ship_weapons[last_ship]=4;
			                    obj_ini.ship_shields[last_ship]=24;
			                    obj_ini.ship_wep[last_ship,1]="Lance Battery";
			                    ship_wep_facing[last_ship,1]="most";
			                    obj_ini.ship_wep_condition[last_ship,1]="";
			                    obj_ini.ship_wep[last_ship,2]="Lance Battery";
								ship_wep_facing[last_ship,2]="most";
			                    obj_ini.ship_wep_condition[last_ship,2]="";
			                    obj_ini.ship_wep[last_ship,3]="Lance Battery";
			                    ship_wep_facing[last_ship,3]="most";
			                    obj_ini.ship_wep_condition[last_ship,3]="";
			                    obj_ini.ship_wep[last_ship,4]="Plasma Cannon";
			                    ship_wep_facing[last_ship,4]="front";
			                    obj_ini.ship_wep_condition[last_ship,4]="";
			                    obj_ini.ship_capacity[last_ship]=800;
			                    obj_ini.ship_carrying[last_ship]=0;
			                    obj_ini.ship_contents[last_ship]="";
			                    obj_ini.ship_turrets[last_ship]=8;
		                    
			                    flit.capital[1]=obj_ini.ship[last_ship];
			                    flit.capital_number=1;
			                    flit.capital_num[1]=last_ship;
			                    flit.capital_uid[1]=obj_ini.ship_uid[last_ship];
			                    flit.oribiting = cur_system.id;
		                    
			                    scr_popup($"Ancient Ship Restored",$"The ancient ship within the ruins of {locy} has been fully repaired.  It is determined to be a Slaughtersong vessel and is bristling with golden age weaponry and armour.  Your {string(obj_ini.role[100][16])}s are excited; the Slaughtersong is ready for it's maiden voyage, at your command.","","");                
			                }
			            }
			        }
			    }
		    }		
		}
	}
}




