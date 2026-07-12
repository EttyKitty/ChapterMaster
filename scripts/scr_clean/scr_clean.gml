/// @function compress_enemy_array
/// @description Compresses column data arrays by removing gaps left by eliminated entities, processes only the first 20 indices
/// @param {id.Instance} _target_column - The column instance to clean up
/// @returns {undefined} No return value; modifies target column directly
function compress_enemy_array(_target_column) {
    if (!instance_exists(_target_column)) {
        return;
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.CLEANUP, $"compress_enemy_array column={obj_ncombat.combat_debugger.resolve_label(_target_column)}");

    with (_target_column) {
        // Define all data arrays to be processed with their default values
        var _data_arrays = [
            {
                arr: dudes,
                def: "",
            },
            {
                arr: dudes_special,
                def: "",
            },
            {
                arr: dudes_num,
                def: 0,
            },
            {
                arr: dudes_ac,
                def: 0,
            },
            {
                arr: dudes_hp,
                def: 0,
            },
            {
                arr: dudes_vehicle,
                def: 0,
            },
            {
                arr: dudes_damage,
                def: 0,
            }
        ];

        // Track which slots are empty
        var _empty_slots = array_create(20, false);
        for (var i = 1; i < array_length(_empty_slots); i++) {
            if (dudes_num[i] <= 0) {
                _empty_slots[i] = true;
            }
        }

        // Compress arrays using a pointer that doesn't restart from beginning
        var pos = 1;
        while (pos < array_length(_empty_slots) - 1) {
            if (_empty_slots[pos] && !_empty_slots[pos + 1]) {
                // Move data from position pos+1 to pos
                for (var j = 0; j < array_length(_data_arrays); j++) {
                    _data_arrays[j].arr[pos] = _data_arrays[j].arr[pos + 1];
                    _data_arrays[j].arr[pos + 1] = _data_arrays[j].def;
                }
                _empty_slots[pos] = false;
                _empty_slots[pos + 1] = true;

                // Only backtrack if we're not at the beginning
                if (pos > 1) {
                    pos--; // Check this position again in case we need to shift more
                }
            } else {
                pos++; // Move to next position
            }
        }
    }
}

/// @function destroy_empty_column
/// @description Destroys the column if it's empty
/// @param {id.Instance} _target_column - The column instance to clean up
function destroy_empty_column(_target_column) {
    // Destroy empty non-player columns to conserve memory and processing.
    with (_target_column) {
        // Count living models straight from dudes_num. men/veh/medi are only refreshed on the enemy's
        // own alarm, so during the player's firing phase they're stale and would leave a wiped-out
        // formation standing - which then keeps getting fired at and blocks "held fire" reporting.
        var _alive = 0;
        for (var r = 1; r < array_length(dudes_num); r++) {
            // A rank chipped to 0 HP but still showing dudes_num is a dead "zombie" - don't count it.
            if (dudes_num[r] > 0 && dudes_hp[r] > 0) {
                _alive += dudes_num[r];
            }
        }
        if ((_alive == 0) && (owner != 1)) {
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.CLEANUP, $"destroy_empty_column column={obj_ncombat.combat_debugger.resolve_label(_target_column)} destroyed");
            instance_destroy();
        }
    }
}

/// @function check_dead_marines
/// @description Checks if the marine is dead and then runs various related code
/// @self Asset.GMObject.obj_pnunit
function check_dead_marines(unit_struct, unit_index) {
    var unit_lost = false;

    if (unit_struct.hp() <= 0 && marine_dead[unit_index] < 1) {
        marine_dead[unit_index] = 1;
        unit_lost = true;
        obj_ncombat.player_forces -= 1;

        // Record loss
        var existing_index = array_get_index(lost, marine_type[unit_index]);
        if (existing_index != -1) {
            lost_num[existing_index] += 1;
        } else {
            array_push(lost, marine_type[unit_index]);
            array_push(lost_num, 1);
        }

        // Check red thirst threadhold
        if (obj_ncombat.red_thirst == 1 && marine_type[unit_index] != "Death Company" && ((obj_ncombat.player_forces / obj_ncombat.player_max) < 0.9)) {
            obj_ncombat.red_thirst = 2;
        }

        if (unit_struct.IsSpecialist(SPECIALISTS_DREADNOUGHTS)) {
            dreads -= 1;
        } else {
            men -= 1;
        }
    }

    return unit_lost;
}

/// @self Id.Instance.obj_pnunit
/// @param {Id.Instance.obj_pnunit} target_object
function scr_clean(target_object, target_is_infantry, hostile_shots, hostile_damage, hostile_weapon, hostile_range, hostile_splash, hostile_armour_pierce, hostile_attack_count) {
    // Converts enemy scr_shoot damage into player marine or vehicle casualties.
    //
    // Parameters:
    // target_object: The obj_pnunit instance taking casualties. Represents the player's rank being attacked.
    // target_is_infantry: Boolean-like value (1 for infantry, 0 for vehicles). Determines whether to process as infantry/dreadnoughts or vehicles.
    // hostile_shots: The number of shots fired at the target. Represents the total hits from the attacking unit.
    // hostile_damage: The amount of damage per shot. This value is reduced by armor or damage resistance before being applied.
    // hostile_weapon: The name of the weapon used in the attack. Certain weapons have special effects that modify damage behavior.
    // hostile_range: The range of the weapon. This may influence damage or other combat mechanics.
    // hostile_splash: The splash damage modifier. Indicates the maximum number of individual targets that can be damaged.
    // hostile_armour_pierce: The armor piercing value of the attack.
    // hostile_attack_count: The maximum number of shots that can land on a single target unit.

    try {
        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.SHOOTING, $"scr_clean target={obj_ncombat.combat_debugger.resolve_label(target_object)} is_infantry={target_is_infantry} shots={hostile_shots} dmg={hostile_damage} weapon={hostile_weapon} range={hostile_range} splash={hostile_splash} ap={hostile_armour_pierce} attack_count={hostile_attack_count}");

        with (target_object) {
            if (obj_ncombat.wall_destroyed == 1) {
                exit;
            }

            var damage_data = {
                "units_lost": 0,
                "unit_type": "",
                "hits": 0,
            };

            // ### Vehicle Damage Processing ###
            if (!target_is_infantry && veh > 0) {
                damage_vehicles(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce, hostile_attack_count, hostile_splash);
            }

            // ### Marine + Dreadnought Processing ###
            if (target_is_infantry && (men + dreads > 0)) {
                damage_infantry(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce, hostile_attack_count, hostile_splash);
            }

            if (damage_data.hits < hostile_shots) {
                // ### Vehicle Damage Processing ###
                if (target_is_infantry && veh > 0) {
                    damage_vehicles(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce, hostile_attack_count, hostile_splash);
                }

                // ### Marine + Dreadnought Processing ###
                if (!target_is_infantry && (men + dreads > 0)) {
                    damage_infantry(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce, hostile_attack_count, hostile_splash);
                }
            }

            scr_flavor2(damage_data.units_lost, damage_data.unit_type, hostile_range, hostile_weapon, damage_data.hits, hostile_splash);

            // ### Cleanup ###
            // If the target_object got wiped out, move it off-screen
            if ((men + veh + dreads) <= 0) {
                x = -5000;
                instance_deactivate_object(id);
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @self Asset.GMObject.obj_pnunit
function damage_infantry(_damage_data, _shots, _damage, _armour_pierce, _attack_count, _splash) {
    // Find valid infantry targets
    var valid_marines = [];
    for (var m = 0, l = array_length(unit_struct); m < l; m++) {
        var unit = unit_struct[m];
        if (is_struct(unit) && unit.hp() > 0 && marine_dead[m] == 0) {
            array_push(valid_marines, m);
        }
    }

    if (array_length(valid_marines) == 0) {
        return;
    }

    // Select up to _splash marines to target for this volley
    var _targeted = [];
    var _hits_remaining = [];
    var _select_count = min(_splash, array_length(valid_marines));
    var _available = [];
    array_copy(_available, 0, valid_marines, 0, array_length(valid_marines));
    for (var t = 0; t < _select_count; t++) {
        var _idx = irandom(array_length(_available) - 1);
        array_push(_targeted, _available[_idx]);
        array_push(_hits_remaining, _attack_count);
        array_delete(_available, _idx, 1);
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_infantry valid_marines={array_length(valid_marines)} targeted={_select_count} shots={_shots} dmg={_damage} ap={_armour_pierce} attack_count={_attack_count} splash={_splash}");

    // Distribute shots among targeted marines
    for (var shot = 0; shot < _shots; shot++) {
        var _candidates = [];
        for (var t = 0; t < array_length(_targeted); t++) {
            var m_idx = _targeted[t];
            if (_hits_remaining[t] > 0 && unit_struct[m_idx].hp() > 0 && marine_dead[m_idx] == 0) {
                array_push(_candidates, t);
            }
        }

        if (array_length(_candidates) == 0) {
            break;
        }

        _damage_data.hits++;

        var _pick = _candidates[irandom(array_length(_candidates) - 1)];
        var marine_index = _targeted[_pick];
        var marine = unit_struct[marine_index];
        _hits_remaining[_pick]--;
        _damage_data.unit_type = marine.role();

        // Apply damage
        var _shot_luck = roll_dice_chapter(1, 100, "low");
        var _modified_damage = 0;
        var _marine_armour = max(0, marine_ac[marine_index] - _armour_pierce);
        if (_shot_luck == 1) {
            _modified_damage = _damage - (2 * _marine_armour);
        } else if (_shot_luck == 100) {
            _modified_damage = _damage;
        } else {
            _modified_damage = _damage - _marine_armour;
        }

        if (_modified_damage > 0) {
            var damage_resistance = marine.damage_resistance() / 100;
            if (marine_mshield[marine_index] > 0) {
                damage_resistance += 0.1;
            }
            if (marine_fiery[marine_index] > 0) {
                damage_resistance += 0.15;
            }
            if (marine_fshield[marine_index] > 0) {
                damage_resistance += 0.08;
            }
            if (marine_quick[marine_index] > 0) {
                damage_resistance += 0.2;
            } // TODO: only if melee
            if (marine_dome[marine_index] > 0) {
                damage_resistance += 0.15;
            }
            if (marine_iron[marine_index] > 0) {
                if (damage_resistance <= 0) {
                    marine.add_or_sub_health(20);
                } else {
                    damage_resistance += marine_iron[marine_index] / 5;
                }
            }
            _modified_damage = round(_modified_damage * (1 - damage_resistance));
        }
        if (_modified_damage < 0 && hostile_weapon == "Fleshborer") {
            _modified_damage = 1.5;
        }

        var _hp_before = marine.hp();
        marine.add_or_sub_health(-_modified_damage);

        // Check if marine is dead
        if (check_dead_marines(marine, marine_index)) {
            _damage_data.units_lost++;
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_infantry marine[{marine_index}] ({_damage_data.unit_type}) KILLED: luck={_shot_luck} armour={_marine_armour} raw_dmg={_damage} mod_dmg={_modified_damage} dr={damage_resistance} hp_before={_hp_before}");
        }
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_infantry done: hits={_damage_data.hits} lost={_damage_data.units_lost}");

    return;
}

/// @self Asset.GMObject.obj_pnunit
function damage_vehicles(_damage_data, _shots, _damage, _armour_pierce, _attack_count, _splash) {
    var veh_index = -1;

    // Find valid vehicle targets
    var valid_vehicles = [];
    for (var v = 0, l = array_length(veh_hp); v < l; v++) {
        if (veh_hp[v] > 0 && veh_dead[v] == 0) {
            array_push(valid_vehicles, v);
        }
    }

    if (array_length(valid_vehicles) == 0) {
        return;
    }

    // Select up to _splash vehicles to target for this volley
    var _targeted = [];
    var _hits_remaining = [];
    var _select_count = min(_splash, array_length(valid_vehicles));
    var _available = [];
    array_copy(_available, 0, valid_vehicles, 0, array_length(valid_vehicles));
    for (var t = 0; t < _select_count; t++) {
        var _idx = irandom(array_length(_available) - 1);
        array_push(_targeted, _available[_idx]);
        array_push(_hits_remaining, _attack_count);
        array_delete(_available, _idx, 1);
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_vehicles valid_vehicles={array_length(valid_vehicles)} targeted={_select_count} shots={_shots} dmg={_damage} ap={_armour_pierce} attack_count={_attack_count} splash={_splash}");

    // Distribute shots among targeted vehicles
    for (var shot = 0; shot < _shots; shot++) {
        var _candidates = [];
        for (var t = 0; t < array_length(_targeted); t++) {
            var v_idx = _targeted[t];
            if (_hits_remaining[t] > 0 && veh_hp[v_idx] > 0 && veh_dead[v_idx] == 0) {
                array_push(_candidates, t);
            }
        }

        if (array_length(_candidates) == 0) {
            break;
        }

        _damage_data.hits++;

        var _pick = _candidates[irandom(array_length(_candidates) - 1)];
        veh_index = _targeted[_pick];
        _hits_remaining[_pick]--;

        // Apply damage
        var _veh_armour = max(0, veh_ac[veh_index] - _armour_pierce);
        var _modified_damage = _damage - _veh_armour;
        if (_modified_damage < 0) {
            _modified_damage = 0;
        }
        if (enemy == 13 && _modified_damage < 1) {
            _modified_damage = 1;
        }
        var _hp_before = veh_hp[veh_index];
        veh_hp[veh_index] -= _modified_damage;
        _damage_data.unit_type = veh_type[veh_index];

        // Check if the vehicle is destroyed
        if (veh_hp[veh_index] <= 0 && veh_dead[veh_index] == 0) {
            veh_dead[veh_index] = 1;
            _damage_data.units_lost++;
            obj_ncombat.player_forces -= 1;
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_vehicles veh[{veh_index}] ({_damage_data.unit_type}) DESTROYED: armour={_veh_armour} raw_dmg={_damage} mod_dmg={_modified_damage} hp_before={_hp_before}");

            // Record loss
            var existing_index = array_get_index(lost, veh_type[veh_index]);
            if (existing_index != -1) {
                lost_num[existing_index] += 1;
            } else {
                array_push(lost, veh_type[veh_index]);
                array_push(lost_num, 1);
            }
        }
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_vehicles done: hits={_damage_data.hits} lost={_damage_data.units_lost}");

    return;
}
