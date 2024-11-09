#macro ITEM_NAME_NONE "(None)"
#macro ITEM_NAME_ANY "(any)"

/// @description This function appends the ITEM_NAME_NONE and ITEM_NAME_ANY to the given list, as requested.
/// @param {array} _item_names - The list of item names to append to.
/// @param {bool} _with_none - Whether to include ITEM_NAME_NONE in the list.
/// @param {bool} _with_any - Whether to include ITEM_NAME_ANY in the list.
function get_none_or_any_item_names(_item_names, _with_none=false, _with_any=false) {
    var expandCount = (_with_any != 0) + (_with_none != 0);
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + expandCount);
    var index = initial_size;
    if (_with_none) {
        _item_names[@ index++] = ITEM_NAME_NONE;
    }
    if (_with_any) {
        _item_names[@ index++] = ITEM_NAME_ANY;
    }
}

/// @description This function returns the hard-coded list of ranged weapons.
/// @param {array} _item_names - The list of ranged weapons to append to.
/// @returns {void}
function push_marine_ranged_weapons_item_names(_item_names) {
    var item_count = 23
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Archeotech Laspistol";
    _item_names[@ index++] = "Assault Cannon";
    _item_names[@ index++] = "Bolt Pistol";
    _item_names[@ index++] = "Bolter";
    _item_names[@ index++] = "Stalker Pattern Bolter";
    _item_names[@ index++] = "Combiflamer";
    _item_names[@ index++] = "Flamer";
    _item_names[@ index++] = "Heavy Bolter";
    _item_names[@ index++] = "Heavy Flamer";
    _item_names[@ index++] = "Hellrifle";
    _item_names[@ index++] = "Incinerator";
    _item_names[@ index++] = "Integrated Bolter";
    _item_names[@ index++] = "Lascannon";
    _item_names[@ index++] = "Lascutter";
    _item_names[@ index++] = "Meltagun";
    _item_names[@ index++] = "Missile Launcher";
    _item_names[@ index++] = "Multi-Melta";
    _item_names[@ index++] = "Autocannon";
    _item_names[@ index++] = "Plasma Gun";
    _item_names[@ index++] = "Plasma Pistol";
    _item_names[@ index++] = "Sniper Rifle";
    _item_names[@ index++] = "Storm Bolter";
    _item_names[@ index++] = "Webber"; // 23
}

/// @description This function returns the hard-coded list of melee weapons.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_marine_melee_weapons_item_names(_item_names) {
    var item_count = 15;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Combat Knife";
    _item_names[@ index++] = "Chainsword";
    _item_names[@ index++] = "Chainaxe";
    _item_names[@ index++] = "Eviscerator";
    _item_names[@ index++] = "Power Sword";
    _item_names[@ index++] = "Power Axe";
    _item_names[@ index++] = "Power Fist";
    _item_names[@ index++] = "Chainfist";
    _item_names[@ index++] = "Lightning Claw";
    _item_names[@ index++] = "Force Staff";
    _item_names[@ index++] = "Thunder Hammer";
    _item_names[@ index++] = "Boarding Shield";
    _item_names[@ index++] = "Storm Shield";
    _item_names[@ index++] = "Bolt Pistol";
    _item_names[@ index++] = "Bolter"; // 15
}


/// @description This function appends the list of marine armour items to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_marine_armour_item_names(_item_names) {
    var item_count = 11;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Scout Armour";
    _item_names[@ index++] = "Power Armour";
    _item_names[@ index++] = "MK3 Iron Armour";
    _item_names[@ index++] = "MK4 Maximus";
    _item_names[@ index++] = "MK5 Heresy";
    _item_names[@ index++] = "MK6 Corvus";
    _item_names[@ index++] = "MK7 Aquila";
    _item_names[@ index++] = "MK8 Errant";
    _item_names[@ index++] = "Artificer Armour";
    _item_names[@ index++] = "Terminator Armour";
    _item_names[@ index++] = "Tartaros"; // 11
}

/// @description This function appends the list of marine gear items to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_marine_gear_item_names(_item_names) {
    var item_count = 4;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    // _item_names[@ index++] = "Bionics";
    _item_names[@ index++] = "Iron Halo";
    _item_names[@ index++] = "Narthecium";
    _item_names[@ index++] = "Psychic Hood";
    _item_names[@ index++] = "Rosarius"; // 4
}

/// @description This function appends the list of marine mobility items to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_marine_mobility_item_names(_item_names) {
    var item_count = 4;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Bike";
    _item_names[@ index++] = "Jump Pack";
    _item_names[@ index++] = "Servo-arm";
    _item_names[@ index++] = "Servo-harness"; // 4
}


/// @description This function appends the list of dreadnought ranged weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_dreadnought_ranged_weapons_item_names(_item_names) {
    var item_count = 10;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Multi-Melta";
    _item_names[@ index++] = "Twin Linked Heavy Flamer Sponsons";
    _item_names[@ index++] = "Plasma Cannon";
    _item_names[@ index++] = "Assault Cannon";
    _item_names[@ index++] = "Autocannon";
    _item_names[@ index++] = "Missile Launcher";
    _item_names[@ index++] = "Twin Linked Lascannon";
    _item_names[@ index++] = "Twin Linked Assault Cannon Mount";
    _item_names[@ index++] = "Twin Linked Heavy Bolter";
    _item_names[@ index++] = "Heavy Conversion Beam Projector"; // 10
}

/// @description This function appends the list of dreadnought melee weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_dreadnought_melee_weapons_item_names(_item_names) {
    var item_count = 3;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Close Combat Weapon";
    _item_names[@ index++] = "Dreadnought Power Claw";
    _item_names[@ index++] = "Dreadnought Lightning Claw"; // 3
}

/// @description This function appends the list of land raider front weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_raider_front_weapons_item_names(_item_names) {
    var item_count = 4;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Twin Linked Heavy Bolter Mount";
    _item_names[@ index++] = "Twin Linked Lascannon Mount";
    _item_names[@ index++] = "Twin Linked Assault Cannon Mount";
    _item_names[@ index++] = "Whirlwind Missiles"; // 4
}

/// @description This function appends the list of land raider relic front weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_raider_relic_front_weapons_item_names(_item_names) {
    var item_count = 2;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    // _item_names[@ index++] = "Thunderfire Cannon Mount";
    _item_names[@ index++] = "Neutron Blaster Turret";
    _item_names[@ index++] = "Reaper Autocannon Mount"; // 2
    // _item_names[@ index++] = "Twin Linked Helfrost Cannon Mount";
    // _item_names[@ index++] = "Graviton Cannon Mount";
}

/// @description This function appends the list of land raider sponson weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_raider_regular_sponsons_item_names(_item_names) {
    var item_count = 3;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Twin Linked Lascannon Sponsons";
    _item_names[@ index++] = "Hurricane Bolter Sponsons";
    _item_names[@ index++] = "Flamestorm Cannon Sponsons"; // 3
}

/// @description This function returns the hard-coded list of land raider relic sponsons.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_raider_relic_sponsons_item_names(_item_names) {
    var item_count = 4;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Quad Linked Heavy Bolter Sponsons";
    _item_names[@ index++] = "Twin Linked Heavy Flamer Sponsons";
    _item_names[@ index++] = "Twin Linked Multi-Melta Sponsons";
    _item_names[@ index++] = "Twin Linked Volkite Culverin Sponsons"; // 4
}

/// @description This function appends the list of land raider pintle weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_raider_pintle_item_names(_item_names) {
    var item_count = 5;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Bolter";
    _item_names[@ index++] = "Combiflamer";
    _item_names[@ index++] = "Twin Linked Bolters";
    _item_names[@ index++] = "Storm Bolter";
    _item_names[@ index++] = "HK Missile"; // 5
}

/// @description This function appends the list of rhino weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_rhino_weapons_item_names(_item_names) {
    var item_count = 5;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Bolter";
    _item_names[@ index++] = "Combiflamer";
    _item_names[@ index++] = "Twin Linked Bolters";
    _item_names[@ index++] = "Storm Bolter";
    _item_names[@ index++] = "HK Missile"; // 5
}

/// @description This function appends the list of predator turret weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_predator_turret_item_names(_item_names) {
    var item_count = 9;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Autocannon Turret";
    _item_names[@ index++] = "Twin Linked Lascannon Turret";
    _item_names[@ index++] = "Flamestorm Cannon Turret";
    _item_names[@ index++] = "Twin Linked Assault Cannon Turret";
    _item_names[@ index++] = "Magna-Melta Turret";
    _item_names[@ index++] = "Plasma Destroyer Turret";
    _item_names[@ index++] = "Heavy Conversion Beam Projector";
    _item_names[@ index++] = "Neutron Blaster Turret";
    _item_names[@ index++] = "Volkite Saker Turret"; // 9
    // _item_names[@ index++] = "Graviton Cannon Turret";
}

/// @description This function appends the list of predator sponson weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_predator_sponsons_item_names(_item_names) {
    var item_count = 4;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Heavy Bolter Sponsons";
    _item_names[@ index++] = "Lascannon Sponsons";
    _item_names[@ index++] = "Heavy Flamer Sponsons";
    _item_names[@ index++] = "Volkite Culverin Sponsons"; // 4
}

/// @description This function appends the list of predator pintle weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_predator_pintle_item_names(_item_names) {
    var item_count = 5;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Bolter";
    _item_names[@ index++] = "Combiflamer";
    _item_names[@ index++] = "Twin Linked Bolters";
    _item_names[@ index++] = "Storm Bolter";
    _item_names[@ index++] = "HK Missile"; // 5
}

/// @description This function appends the list of land speeder primary weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_speeder_primary_item_names(_item_names) {
    var item_count = 2;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Multi-Melta";
    _item_names[@ index++] = "Heavy Bolter"; // 2
}

/// @description This function appends the list of land speeder secondary weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_land_speeder_secondary_item_names(_item_names) {
    var item_count = 2;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Heavy Flamer";
    _item_names[@ index++] = "Assault Cannon"; // 2
}

/// @description This function appends the list of whirlwind missiles to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_whirlwind_missiles_item_names(_item_names) {
    _item_names[@ array_length(_item_names)] = "Whirlwind Missiles";
}

/// @description This function appends the list of whirlwind pintle weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {void}
function push_whirlwind_pintle_item_names(_item_names) {
    var item_count = 5;
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    _item_names[@ index++] = "Bolter";
    _item_names[@ index++] = "Combiflamer";
    _item_names[@ index++] = "Twin Linked Bolters";
    _item_names[@ index++] = "Storm Bolter";
    _item_names[@ index++] = "HK Missile"; // 5
}

/// @description This function appends the list of tank upgrade items to the given list.
/// @param {array} _item_names - The list to append to.
/// @param {bool} _is_land_raider - Whether the tank is a land raider.
/// @returns {void}
function push_tank_upgrade_item_names(_item_names, _is_land_raider=false) {
    var item_count = 3 + (_is_land_raider != 0);
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    // array_push(_item_names, "Armoured Ceramite");
    // array_push(_item_names, "Artificer Hull");
    // array_push(_item_names, "Heavy Armour");
    // if (_is_land_raider) {
    //     array_push(_item_names, "Void Shield");
    // }
    _item_names[@ index++] = "Armoured Ceramite";
    _item_names[@ index++] = "Artificer Hull";
    _item_names[@ index++] = "Heavy Armour";
    if (_is_land_raider) {
        _item_names[@ index++] = "Void Shield";
    }
}

/// @description This function appends the list of tank accessory items to the given list.
/// @param {array} _item_names - The list to append to.
/// @param {bool} _is_land_raider - Whether the tank is a land raider.
/// @param {bool} _is_dreadnought - Whether the 'tank' is a dreadnought.
/// @returns {void}
function push_tank_accessory_item_names(_item_names, _is_land_raider=false, _is_dreadnought=false) {
    var item_count = 3 + (!_is_dreadnought) + (!_is_land_raider && !_is_dreadnought);
    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + item_count);

    var index = initial_size;
    if (!_is_dreadnought) {
        _item_names[@ index++] = "Dozer Blades";
    }
    _item_names[@ index++] = "Searchlight";
    _item_names[@ index++] = "Smoke Launchers";
    _item_names[@ index++] = "Frag Assault Launchers";
    if (!_is_land_raider && !_is_dreadnought) {
        _item_names[@ index++] = "Lucifer Pattern Engine";
    }
}

/// @description Returns a list of equipment names filtered by given criteria.
/// @param {array} _item_names - The list of item names to append to.
/// @param {string} _equip_category - The category of equipment ("weapon", "armour", "gear", "mobility").
/// @param {bool} _melee_or_ranged - Whether the equipment is melee or ranged. true for melee, false for ranged.
/// @param {bool} _is_master_crafted - Whether to include only master-crafted items.
/// @param {array} _required_tags - Tags that the equipment must have.
/// @param {array} _excluded_tags - Tags that the equipment must not have.
/// @param {bool} _with_none - Include "(None)" in the list.
/// @param {bool} _with_any - Include "(any)" in the list.
/// @returns {array} item_names - The filtered list of equipment names.
function get_filtered_equipment_item_names(_item_names, _equip_category, _melee_or_ranged, _is_master_crafted=false, _required_tags=undefined, _excluded_tags=undefined, _with_none=false, _with_any=false) {
    get_none_or_any_item_names(_item_names, _with_none, _with_any);

    var matched_indexes = [];

    for (var _i = 0; _i < array_length(obj_ini.equipment); _i++) {
        if (_is_master_crafted && !array_contains(obj_ini.equipment_quality[_i], "master_crafted")) {
            continue;
        }

        var equip_data = gear_weapon_data(_equip_category, obj_ini.equipment[_i]);
        if (!is_struct(equip_data) || obj_ini.equipment_number[_i] <= 0) {
            continue;
        }

        if (_melee_or_ranged != undefined) {
            if ((_melee_or_ranged && equip_data.range > 1.1) || (!_melee_or_ranged && equip_data.range <= 1.1)) {
                continue;
            }
        }

        // Check required tags
        var valid = true;
        if (_required_tags != undefined) {
            for (var _t = 0; _t < array_length(_required_tags); _t++) {
                if (!equip_data.has_tag(_required_tags[_t])) {
                    valid = false;
                    break;
                }
            }
        }

        // Check excluded tags
        if (valid && _excluded_tags != undefined) {
            for (var _t = 0; _t < array_length(_excluded_tags); _t++) {
                if (equip_data.has_tag(_excluded_tags[_t])) {
                    valid = false;
                    break;
                }
            }
        }

        if (valid) {
            array_push(matched_indexes, _i);
        }
    }

    var initial_size = array_length(_item_names);
    array_resize(_item_names, initial_size + array_length(matched_indexes));

    var index = initial_size;
    for (var j = 0; j < array_length(matched_indexes); j++) {
        var equip_index = matched_indexes[j];
        var equip_data = gear_weapon_data(_equip_category, obj_ini.equipment[equip_index]);
        _item_names[@ index++] = equip_data.name;
    }

    return _item_names;
}

enum eEQUIPMENT_TYPE {
    None,
    PrimaryWeapon = 1,  // LeftHand, Turret, Front, Primary
    SecondaryWeapon = 2,  // RightHand, Sponson, Secondary
    Armour = 3,
    GearUpgrade = 4,
    MobilityAccessory = 5
}

enum eEQUIPMENT_SUBTYPE {
    None,
    Ranged = 1, // Regular land raider weapons
    Melee = 2 // Relic land raider weapons
}

enum eUNIT_TYPE {
    None,
    Infantry = 1,
    HonorGuard = 2,
    Veteran = 3,
    Terminator = 4,
    Captain = 5,
    Dreadnought = 6,
    Champion = 7,
    TacticalMarine = 8,
    DevastatorMarine = 9,
    AssaultMarine = 10,
    Ancient = 11,
    Scout = 12,
    Chaplain = 14,
    Apothecary = 15,
    Techmarine = 16,
    Librarian = 17,
    Sergeant = 18,
    VeteranSergeant = 19,
    LandRaider = 50,
    Rhino = 51,
    Predator = 52,
    LandSpeeder = 53,
    Whirlwind = 54
}

/// @description This function returns the name of the slot for a given unit type and equipment type.
/// @param {eUNIT_TYPE} _unit_type - The type of unit to equip, see eUNIT_TYPE.
/// @param {eEQUIPMENT_TYPE} _equipment_type - The type of equipment to equip, see eEQUIPMENT_TYPE.
/// @returns {string} The name of the slot.
function get_slot_name(_unit_type, _equipment_type) {
    switch (_unit_type) {
        case eUNIT_TYPE.Infantry:
        case eUNIT_TYPE.HonorGuard:
        case eUNIT_TYPE.Veteran:
        case eUNIT_TYPE.Terminator:
        case eUNIT_TYPE.Captain:
        case eUNIT_TYPE.Champion:
        case eUNIT_TYPE.TacticalMarine:
        case eUNIT_TYPE.DevastatorMarine:
        case eUNIT_TYPE.AssaultMarine:
        case eUNIT_TYPE.Ancient:
        case eUNIT_TYPE.Scout:
        case eUNIT_TYPE.Chaplain:
        case eUNIT_TYPE.Apothecary:
        case eUNIT_TYPE.Techmarine:
        case eUNIT_TYPE.Librarian:
        case eUNIT_TYPE.Sergeant:
        case eUNIT_TYPE.VeteranSergeant:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Left Hand";
                case eEQUIPMENT_TYPE.SecondaryWeapon: return "Right Hand";
                case eEQUIPMENT_TYPE.Armour: return "Armour";
                case eEQUIPMENT_TYPE.GearUpgrade: return "Gear";
                case eEQUIPMENT_TYPE.MobilityAccessory: return "Mobility";
                default: return "Unknown";
            }
        case eUNIT_TYPE.Dreadnought:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Left Arm";
                case eEQUIPMENT_TYPE.SecondaryWeapon: return "Right Arm";
                case eEQUIPMENT_TYPE.MobilityAccessory: return "Accessory";
                default: return "Unknown";
            }
        case eUNIT_TYPE.LandRaider:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Front";
                case eEQUIPMENT_TYPE.SecondaryWeapon: return "Sponson";
                case eEQUIPMENT_TYPE.Armour: return "Pintle";
                case eEQUIPMENT_TYPE.GearUpgrade: return "Upgrade";
                case eEQUIPMENT_TYPE.MobilityAccessory: return "Accessory";
                default: return "Unknown";
            }
        case eUNIT_TYPE.Rhino:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Weapon";
                case eEQUIPMENT_TYPE.GearUpgrade: return "Upgrade";
                case eEQUIPMENT_TYPE.MobilityAccessory: return "Accessory";
                default: return "Unknown";
            }
        case eUNIT_TYPE.Predator:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Turret";
                case eEQUIPMENT_TYPE.SecondaryWeapon: return "Sponsons";
                case eEQUIPMENT_TYPE.Armour: return "Pintle";
                case eEQUIPMENT_TYPE.GearUpgrade: return "Upgrade";
                case eEQUIPMENT_TYPE.MobilityAccessory: return "Accessory";
                default: return "Unknown";
            }
        case eUNIT_TYPE.LandSpeeder:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Primary";
                case eEQUIPMENT_TYPE.SecondaryWeapon: return "Secondary";
                default: return "Unknown";
            }
        case eUNIT_TYPE.Whirlwind:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: return "Missiles";
                case eEQUIPMENT_TYPE.SecondaryWeapon: return "Pintle";
                case eEQUIPMENT_TYPE.GearUpgrade: return "Upgrade";
                case eEQUIPMENT_TYPE.MobilityAccessory: return "Accessory";
                default: return "Unknown";
            }
        default:
            return "Unknown";
    }
}

/// @description This function is used to populate the weapon/equipment selection list in the equipment screen.
/// @param {array} _item_names - The list of items to populate the selection list with.
/// @param {real} _equipment_type - The type of equipment to equip, see eEQUIPMENT_TYPE.
/// @param {real} _equipment_subtype - The subtype of equipment to equip, see eEQUIPMENT_SUBTYPE.
/// @param {real} _unit_type - The type of unit to equip, see eUNIT_TYPE.
/// @param {bool} _include_company_standard - Whether to include the Company Standard in the selection list.
/// @param {bool} _show_available_only - Whether to limit the selection to what is in inventory, or show all items.
/// @param {bool} _master_crafted_only - Whether to show only master crafted items, or hide them.
/// @param {bool} _skip_none - Omit the "(None)" option from the list. This help us avoid duplicates when combining range & melee hand weapons.
/// @returns {array} The list of items to populate the selection list with.
function scr_get_item_names(_item_names, _equipment_type, _equipment_subtype, _unit_type, _include_company_standard=false, _show_available_only=false, _master_crafted_only=false, _skip_none=false) {
    if (_item_names == undefined) {
        assert_error_popup("_item_names is undefined");
        return;
    }
    if (!is_array(_item_names)) {
        assert_error_popup("_item_names is not an array: " + string(_item_names));
        return;
    }

    var _with_none_if_not_skip = _skip_none ? false : true;

    switch(_unit_type) {
        case eUNIT_TYPE.Infantry:
        case eUNIT_TYPE.HonorGuard:
        case eUNIT_TYPE.Veteran:
        case eUNIT_TYPE.Terminator:
        case eUNIT_TYPE.Captain:
        case eUNIT_TYPE.Champion:
        case eUNIT_TYPE.TacticalMarine:
        case eUNIT_TYPE.DevastatorMarine:
        case eUNIT_TYPE.AssaultMarine:
        case eUNIT_TYPE.Ancient:
        case eUNIT_TYPE.Scout:
        case eUNIT_TYPE.Chaplain:
        case eUNIT_TYPE.Apothecary:
        case eUNIT_TYPE.Techmarine:
        case eUNIT_TYPE.Librarian:
        case eUNIT_TYPE.Sergeant:
        case eUNIT_TYPE.VeteranSergeant:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) {
                        if (_show_available_only) {
                            get_filtered_equipment_item_names(
                                _item_names,
                                "weapon",
                                false, // ranged
                                _master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                _with_none_if_not_skip,
                                true  // with_any
                            );
                        } else {
                            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                            push_marine_ranged_weapons_item_names(_item_names);
                        }
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) {
                        if (_show_available_only) {
                            get_filtered_equipment_item_names(
                                _item_names,
                                "weapon",
                                true, // melee
                                _master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                _with_none_if_not_skip,
                                true // with_any
                            );
                            if (_include_company_standard) {
                                _item_names[@ array_length(_item_names)] = "Company Standard";
                            }
                        } else {
                            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                            push_marine_melee_weapons_item_names(_item_names);
                        }
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.None) {
                        if (_show_available_only) {
                            get_filtered_equipment_item_names(
                                _item_names,
                                "weapon",
                                undefined, // no range filter
                                _master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                _with_none_if_not_skip,
                                true // with_any
                            );
                        } else {
                            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                            push_marine_ranged_weapons_item_names(_item_names);
                            push_marine_melee_weapons_item_names(_item_names);
                        }
                    } else {
                        assert_error_popup("Invalid equipment subtype for infantry: " + string(_equipment_subtype));
                        return;
                    }
                    break;
                case eEQUIPMENT_TYPE.Armour:
                    if (_show_available_only) {
                        _item_names = get_filtered_equipment_item_names(
                            _item_names,
                            "armour",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle armour
                            _with_none_if_not_skip,
                            true // with_any
                        );
                    } else {
                        get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                        push_marine_armour_item_names(_item_names);
                    }
                    break;
                case eEQUIPMENT_TYPE.GearUpgrade:
                    if (_show_available_only) {
                        get_filtered_equipment_item_names(
                            _item_names,
                            "gear",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle gear
                            _with_none_if_not_skip,
                            true // with_any
                        );
                    } else {
                        get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                        push_marine_gear_item_names(_item_names);
                    }
                    break;
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    if (_show_available_only) {
                        get_filtered_equipment_item_names(
                            _item_names,
                            "mobility",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle mobility
                            _with_none_if_not_skip,
                            true // with_any
                        );
                    } else {
                        get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                        push_marine_mobility_item_names(_item_names);
                    }
                    break;
                default:
                    assert_error_popup("Invalid equipment type for infantry: " + string(_equipment_type));
                    return;
            }        
            break;
        case eUNIT_TYPE.Dreadnought:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) {
                        if (_show_available_only) {
                            get_filtered_equipment_item_names(
                                _item_names,
                                "weapon",
                                false, // ranged
                                _master_crafted_only,
                                ["dreadnought"], // required tags
                                undefined, // no excluded tags
                                _with_none_if_not_skip,
                                true // with_any
                            );
                        } else {
                            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                            push_dreadnought_ranged_weapons_item_names(_item_names);
                        }
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) {
                        if (_show_available_only) {
                            get_filtered_equipment_item_names(
                                _item_names,
                                "weapon",
                                true, // melee
                                _master_crafted_only,
                                ["dreadnought"], // required tags
                                undefined, // no excluded tags
                                _with_none_if_not_skip,
                                true // with_any
                            );
                        } else {
                            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                            push_dreadnought_melee_weapons_item_names(_item_names);
                        }
                    } else {
                        assert_error_popup("Invalid equipment subtype for dreadnought: " + string(_equipment_subtype));
                        return;
                    }
                    break;
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
                    push_tank_accessory_item_names(_item_names, false, true);
                    break;
                case eEQUIPMENT_TYPE.Armour:
                case eEQUIPMENT_TYPE.GearUpgrade:
                    // Dreadnought doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    assert_error_popup("Invalid equipment type for dreadnought: " + string(_equipment_type));
                    return;
            }
            break;
        case eUNIT_TYPE.LandRaider:
            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) { // Regular land raider weapons
                        push_land_raider_front_weapons_item_names(_item_names);
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) { // Relic land raider weapons
                        push_land_raider_relic_front_weapons_item_names(_item_names);
                    } else {
                        assert_error_popup("Invalid equipment subtype for land raider: " + string(_equipment_subtype));
                        return;
                    }
                    break;
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) { // Regular land raider weapons
                        push_land_raider_regular_sponsons_item_names(_item_names);
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) { // Relic land raider weapons
                        push_land_raider_relic_sponsons_item_names(_item_names);
                    } else {
                        assert_error_popup("Invalid equipment subtype for land raider: " + string(_equipment_subtype));
                        return;
                    }
                    break;
                case eEQUIPMENT_TYPE.Armour: push_land_raider_pintle_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(_item_names, _with_none_if_not_skip); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(_item_names, _with_none_if_not_skip, false); break;
                default:
                    assert_error_popup("Invalid equipment type for land raider: " + string(_equipment_type));
                    return;
            }
            break;
        case eUNIT_TYPE.Rhino:
            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_rhino_weapons_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(_item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(_item_names, false, false); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                case eEQUIPMENT_TYPE.Armour:
                    // Rhino doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    assert_error_popup("Invalid equipment type for rhino: " + string(_equipment_type));
                    return;
            }
            break;
        case eUNIT_TYPE.Predator:
            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_predator_turret_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: push_predator_sponsons_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.Armour: push_predator_pintle_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(_item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(_item_names, false, false); break;
                default:
                    assert_error_popup("Invalid equipment type for predator: " + string(_equipment_type));
                    return;
            }
            break;
        case eUNIT_TYPE.LandSpeeder:
            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_land_speeder_primary_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: push_land_speeder_secondary_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade:
                case eEQUIPMENT_TYPE.Armour:
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    // Land speeder doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    assert_error_popup("Invalid equipment type for land speeder: " + string(_equipment_type));
                    return;
            }
            break;
        case eUNIT_TYPE.Whirlwind:
            get_none_or_any_item_names(_item_names, _with_none_if_not_skip, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_whirlwind_missiles_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: push_whirlwind_pintle_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(_item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(_item_names, false, false); break;
                case eEQUIPMENT_TYPE.Armour:
                    // Whirlwind doesn't have this equipment type, but an empty list is shown in the UI
                    break;
                default:
                    assert_error_popup("Invalid equipment type for whirlwind: " + string(_equipment_type));
                    return;
            }
            break;
    }
}
