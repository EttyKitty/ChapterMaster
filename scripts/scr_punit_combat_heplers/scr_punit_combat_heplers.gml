// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function target_block_is_valid(target, desired_type){
	var _is_valid = false
	if (target=="none") then return false;
	if (instance_exists(target)){
		if (target.x>0 && target.object_index == desired_type){
			if (target.men+target.veh+target.dreads>0){
				_is_valid=true
			}
			else {
				x=-5000;
				instance_deactivate_object(id);
			}
		}
	}
	return _is_valid;
}

function get_rightmost(block_type=obj_pnunit){
	var rightmost = "none";
	if (instance_exists(block_type)){
		with (block_type){
			if x<=0 then continue;
			if (men+veh+dreads<=0){
				x=-5000;
				instance_deactivate_object(id);
				continue;
			}
			if(rightmost=="none" && x >0){
				rightmost=block_type.id;
			} else {
				if (x>rightmost.x){
					rightmost = id;
				}
			}
		}
	}
	return rightmost;
}

function block_has_armour(target){
	return target.veh+target.dreads;
}

function get_leftmost(block_type=obj_pnunit, include_flanking=true){
	var left_most = "none";
	if (instance_exists(block_type)){
		with (block_type){
			if (!include_flanking && flank) then continue;
			if x<=0 then continue;
			if (men+veh+dreads<=0){
				x=-5000;
				instance_deactivate_object(id);
				continue;
			}			
			if(left_most=="none" && x >0){
				left_most=block_type.id;
			} else {
				if (x<left_most.x && x>0){
					left_most = id;
				}
			}
		}
	}
	return left_most;
}
function get_block_distance(block){
	return point_distance(x,y,block.x,block.y)/10;
}
function move_unit_block(direction="east", blocks=1){
	distance = 10*blocks;
	if (direction=="east"){
		x+=distance;
	}
	else if (direction=="west"){
		x-=distance;
	}
}