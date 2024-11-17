// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_fleet_ships_to_combat(fleet, combat){
	var capital_count = array_length(fleet.capital);
	var _ship_id;
	var _ships = fleet_full_ship_array(fleet);
	var _ship_array_length = array_length(_ships);
	for (var i=0;i<_ship_array_length;i++){
		_ship_id = _ships[i];
		if (obj_ini.ship_hp[_ship_id]<=0 || obj_ini.ship[_ship_id]==""){
			array_delete(_ships,i,1);
			i--;
			_ship_array_length--;
		}
        if (obj_ini.ship_size[_ship_id]>=3) then combat.capital++;
        if (obj_ini.ship_size[_ship_id]==2) then combat.frigate++;
        if (obj_ini.ship_size[_ship_id]==1) then combat.escort++;
        
        array_push(combat.ship_class, player_ships_class(_ship_id));
        array_push(combat.ship, obj_ini.ship[_ship_id]);
        array_push(combat.ship_id, _ship_id);
        array_push(combat.ship_size, obj_ini.ship_size[_ship_id]);
        array_push(combat.ship_leadership, 100);
        array_push(combat.ship_hp, obj_ini.ship_hp[_ship_id]);
        array_push(combat.ship_maxhp, obj_ini.ship_maxhp[_ship_id]);
        array_push(combat.ship_conditions, obj_ini.ship_conditions[_ship_id]);
        array_push(combat.ship_speed, obj_ini.ship_speed[_ship_id]);
        array_push(combat.ship_turning, obj_ini.ship_turning[_ship_id]);
        array_push(combat.ship_front_armour, obj_ini.ship_front_armour[_ship_id]);
        array_push(combat.ship_other_armour, obj_ini.ship_other_armour[_ship_id]);
        array_push(combat.ship_weapons, obj_ini.ship_weapons[_ship_id]);
        
        array_push(combat.ship_wep, obj_ini.ship_wep[_ship_id]);
        array_push(combat.ship_wep_facing, obj_ini.ship_wep_facing[_ship_id]);
        array_push(combat.ship_wep_condition, obj_ini.ship_wep_condition[_ship_id]);
        
        array_push(combat.ship_capacity, obj_ini.ship_capacity[_ship_id]);
        array_push(combat.ship_carrying, obj_ini.ship_carrying[_ship_id]);
        array_push(combat.ship_contents, obj_ini.ship_contents[_ship_id]);
        array_push(combat.ship_turrets, obj_ini.ship_turrets[_ship_id]);		
	}
}

function sort_ships_into_columns(combat){
	var col = 5;
	with (combat){
	    for (var k = 0;k<array_length(combat.ship_size);k++){// This determines the number of ships in each column
            if ((combat.column[col]="Capital") and (combat.ship_size[k]>=3)) then combat.column_num[col]+=1;
            if ((combat.column[col-1]="Capital") and (combat.ship_size[k]>=3)) then combat.column_num[col-1]+=1;
            if ((combat.column[col-2]="Capital") and (combat.ship_size[k]>=3)) then combat.column_num[col-2]+=1;
            if ((combat.column[col-3]="Capital") and (combat.ship_size[k]>=3)) then combat.column_num[col-3]+=1;
            if ((combat.column[col-4]="Capital") and (combat.ship_size[k]>=3)) then combat.column_num[col-4]+=1;
        
            if (combat.ship_class[k]=combat.column[col]) then combat.column_num[col]+=1;
            if (combat.ship_class[k]=combat.column[col-1]) then combat.column_num[col-1]+=1;
            if (combat.ship_class[k]=combat.column[col-2]) then objs_fleet.column_num[col-2]+=1;
            if (combat.ship_class[k]=combat.column[col-3]) then combat.column_num[col-3]+=1;
            if (combat.ship_class[k]=combat.column[col-4]) then combat.column_num[col-4]+=1;
            
            if ((combat.column[col]="Escort") and (combat.ship_size[k]=1)) then combat.column_num[col]+=1;
            if ((combat.column[col-1]="Escort") and (combat.ship_size[k]=1)) then combat.column_num[col-1]+=1;
            if ((combat.column[col-2]="Escort") and (combat.ship_size[k]=1)) then combat.column_num[col-2]+=1;
            if ((combat.column[col-3]="Escort") and (combat.ship_size[k]=1)) then combat.column_num[col-3]+=1;
            if ((combat.column[col-4]="Escort") and (combat.ship_size[k]=1)) then combat.column_num[col-4]+=1;
	    }		
	}

}


function player_fleet_ship_spawner(){
	var x2 = 224;
	var hei=0,sizz=0;
	for (var col=5;col>0;col--){// Start repeat
	    temp1=0;
	    temp2=0;

	    if (col<5) then x2-=column_width[col];

		if (column_num[col]>0){// Start ship creation
		    if (column[col]="Capital"){
		    	hei=160;
		    	sizz=3;
		    }
		    // if (column[col]="Slaughtersong"){hei=200;sizz=3;}
		    if (column[col]="Strike Cruiser"){hei=96;sizz=2;}
		    if (column[col]="Gladius"){hei=64;sizz=1;}
		    if (column[col]="Hunter"){hei=64;sizz=1;}
		    if (column[col]="Escort"){hei=64;sizz=1;}

		    temp1=column_num[col]*hei;
		    temp2=((room_height/2)-(temp1/2))+64;
		    if (column_num[col]=1) then temp2+=20;
		    
		    // show_message(string(column_num[col])+" "+string(column[col])+" X:"+string(x2));
		    for (var k = 0;k<array_length(ship_class);k++){
		        if (ship_class[k]=column[col]) or (column[col]="Escort" && ship_size[k]=1) or ((column[col]="Capital") and (ship_size[k]=3)){
		            if (sizz>=3) and (ship_class[k]!="") {
		            	man=instance_create(x2,temp2,obj_p_capital);
		            	man.ship_id=k;man.class=column[col];temp2+=hei;
		            }
		            if (sizz=2) and (ship_class[k]!="") {
		            	man=instance_create(x2,temp2,obj_p_cruiser);
		            	man.ship_id=k;
		            	man.class=column[col];
		            	temp2+=hei;
		            }
		            if (sizz=1) and (ship_class[k]!="") {man=instance_create(x2,temp2,obj_p_escort);man.ship_id=k;man.class=column[col];temp2+=hei;}
		        }
		    }
		    

		}// End ship creation




	}// End repeat	
}



