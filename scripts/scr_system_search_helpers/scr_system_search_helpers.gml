// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function scr_get_planet_with_feature(star, feature){
	for(var i = 1; i <= star.planets; i++){
		if(planet_feature_bool(star.p_feature[i], feature) == 1)
			{
				return i;
			}
		}
	return -1;
}

function NSystemSearchHelpers() {
	static default_allies = [
		eFACTION.Player,
		eFACTION.Imperium,
		eFACTION.Mechanicus,
		eFACTION.Inquisition,
		eFACTION.Ecclesiarchy
	]
}
NSystemSearchHelpers()

function scr_star_has_planet_with_feature(star, feature){
	return scr_get_planet_with_feature(star, feature) != -1;
}

function scr_is_planet_owned_by_allies(star, planet_idx) {
	if planet_idx < 1 //1 because weird indexing starting at 1 in this game
		return false;
	return array_contains(NSystemSearchHelpers.default_allies, star.p_owner[planet_idx])
}

function scr_is_star_owned_by_allies(star) {
	return array_contains(NSystemSearchHelpers.default_allies, star.owner)
}

function scr_get_planet_with_type(star, type){
	for(var i = 1; i <= star.planets; i++){
		if(star.p_type[i] == type)
			{
				return i;
			}
		}
	return -1;
}

function scr_star_has_planet_with_type(star, type){
	return scr_get_planet_with_type(star,type) != -1;
}

function scr_get_planet_with_owner(star, owner){
	for(var i = 1; i <= star.planets; i++){
		if(star.p_owner[i] == owner)
			{
				return i;
			}
		}
	return -1;
}

function scr_star_has_planet_with_owner(star, owner){
	return scr_get_planet_with_owner(star,owner) != -1;
}

function scr_get_stars() {
	var stars = [];
	with(obj_star){
		array_push(stars,id);
	}
	return stars;
}

function planet_imperium_ground_total(planet_check){
    return p_guardsmen[planet_check]+p_pdf[planet_check]+p_sisters[planet_check]+p_player[planet_check];
}

function star_by_name(search_name){
	with(obj_star){
		if (name = search_name){
			return self;
		}
	}
	return "none";
}

function distance_removed_star(origional_x,origional_y, star_offset = choose(2,3), disclude_hulk=true, disclude_elder=true){
	var from = instance_nearest(origional_x,origional_y,obj_star);
    for(var i=0; i<star_offset; i++){
        from=instance_nearest(origional_x,origional_y,obj_star);
        if (disclude_elder && from.owner=eFACTION.Eldar){
        	i--;
        }
        with(from){
        	instance_deactivate_object(id);
        };
    }
    from=instance_nearest(origional_x,origional_y,obj_star);
    instance_activate_object(obj_star);
    return from;     
}



//function scr_get_player_fleets() {
//	var player_fleets = [];
//	with(obj_p_fleet){
//		array_push(player_fleets,id);
//	}
//	return player_fleets;
//}