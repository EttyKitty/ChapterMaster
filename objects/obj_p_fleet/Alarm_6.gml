
// show_message("Post-combat cleanup at obj_p_fleet.alarm[1]");


/*with(obj_ini){
    scr_dead_marines(2);
}

with(obj_ini){scr_ini_ship_cleanup();}*/



with(obj_ini){scr_ini_ship_cleanup();}

if (capital_number<0) then capital_number=0;
if (frigate_number<0) then frigate_number=0;
if (escort_number<0) then escort_number=0;

if (capital_uid[1]=0) and (frigate_uid[1]=0) and (escort_uid[1]=0) then instance_destroy();

// if ((capital_number+frigate_number+escort_number)<=0) then instance_destroy();


/* */
/*  */
