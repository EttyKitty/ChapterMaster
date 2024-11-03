global.item_name_none = "(None)";
global.item_name_any = "(any)";

/// @description This function returns an array with common empty or wildcard names as needed.
/// @param {bool} _with_none - Whether to include global.item_name_none in the list.
/// @param {bool} _with_any - Whether to include global.item_name_any in the list.
function get_none_or_any_item_names(_with_none=false, _with_any=false) {
    var _item_names = [];
    if (_with_none) {
        array_push(_item_names, global.item_name_none);
    }
    if (_with_any) {
        array_push(_item_names, global.item_name_any);
    }
    return _item_names;
}

/// @description This function returns the hard-coded list of ranged weapons.
/// @param {array} _item_names - The list of ranged weapons to append to.
/// @returns {array} The appended list.
function push_marine_ranged_weapons_item_names(_item_names) {
    array_push(_item_names, "Archeotech Laspistol");
    array_push(_item_names, "Assault Cannon");
    array_push(_item_names, "Bolt Pistol");
    array_push(_item_names, "Bolter");
    array_push(_item_names, "Stalker Pattern Bolter");
    array_push(_item_names, "Combiflamer");
    array_push(_item_names, "Flamer");
    array_push(_item_names, "Heavy Bolter");
    array_push(_item_names, "Heavy Flamer");
    array_push(_item_names, "Hellrifle");
    array_push(_item_names, "Incinerator");
    array_push(_item_names, "Integrated Bolter");
    array_push(_item_names, "Lascannon");
    array_push(_item_names, "Lascutter");
    array_push(_item_names, "Meltagun");
    array_push(_item_names, "Missile Launcher");
    array_push(_item_names, "Multi-Melta");
    array_push(_item_names, "Autocannon");
    array_push(_item_names, "Plasma Gun");
    array_push(_item_names, "Plasma Pistol");
    array_push(_item_names, "Sniper Rifle");
    array_push(_item_names, "Storm Bolter");
    array_push(_item_names, "Webber");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function returns the hard-coded list of melee weapons.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_marine_melee_weapons_item_names(_item_names) {
    array_push(_item_names, "Combat Knife");
    array_push(_item_names, "Chainsword");
    array_push(_item_names, "Chainaxe");
    array_push(_item_names, "Eviscerator");
    array_push(_item_names, "Power Sword");
    array_push(_item_names, "Power Axe");
    array_push(_item_names, "Power Fist");
    array_push(_item_names, "Chainfist");
    array_push(_item_names, "Lightning Claw");
    array_push(_item_names, "Force Staff");
    array_push(_item_names, "Thunder Hammer");
    array_push(_item_names, "Boarding Shield");
    array_push(_item_names, "Storm Shield");
    array_push(_item_names, "Bolt Pistol");
    array_push(_item_names, "Bolter");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}


/// @description This function appends the list of marine armour items to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_marine_armour_item_names(_item_names) {
    array_push(_item_names, "Scout Armour");
    array_push(_item_names, "Power Armour");
    array_push(_item_names, "MK3 Iron Armour");
    array_push(_item_names, "MK4 Maximus");
    array_push(_item_names, "MK5 Heresy");
    array_push(_item_names, "MK6 Corvus");
    array_push(_item_names, "MK7 Aquila");
    array_push(_item_names, "MK8 Errant");
    array_push(_item_names, "Artificer Armour");
    array_push(_item_names, "Terminator Armour");
    array_push(_item_names, "Tartaros");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of marine gear items to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_marine_gear_item_names(_item_names) {
    // array_push(item_names, "Bionics");
    array_push(_item_names, "Iron Halo");
    array_push(_item_names, "Narthecium");
    array_push(_item_names, "Psychic Hood");
    array_push(_item_names, "Rosarius");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of marine mobility items to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_marine_mobility_item_names(_item_names) {
    array_push(_item_names, "Bike");
    array_push(_item_names, "Jump Pack");
    array_push(_item_names, "Servo-arm");
    array_push(_item_names, "Servo-harness");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}


/// @description This function appends the list of dreadnought ranged weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_dreadnought_ranged_weapons_item_names(_item_names) {
    array_push(_item_names, "Multi-Melta");
    array_push(_item_names, "Twin Linked Heavy Flamer Sponsons");
    array_push(_item_names, "Plasma Cannon");
    array_push(_item_names, "Assault Cannon");
    array_push(_item_names, "Autocannon");
    array_push(_item_names, "Missile Launcher");
    array_push(_item_names, "Twin Linked Lascannon");
    array_push(_item_names, "Twin Linked Assault Cannon Mount");
    array_push(_item_names, "Twin Linked Heavy Bolter");
    array_push(_item_names, "Heavy Conversion Beam Projector");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of dreadnought melee weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_dreadnought_melee_weapons_item_names(_item_names) {
    array_push(_item_names, "Close Combat Weapon");
    array_push(_item_names, "Dreadnought Power Claw");
    array_push(_item_names, "Dreadnought Lightning Claw");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of land raider front weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_raider_front_weapons_item_names(_item_names) {
    array_push(_item_names, "Twin Linked Heavy Bolter Mount");
    array_push(_item_names, "Twin Linked Lascannon Mount");
    array_push(_item_names, "Twin Linked Assault Cannon Mount");
    array_push(_item_names, "Whirlwind Missiles");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of land raider relic front weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_raider_relic_front_weapons_item_names(_item_names) {
    // array_push(_item_names, "Thunderfire Cannon Mount");
    array_push(_item_names, "Neutron Blaster Turret");
    array_push(_item_names, "Reaper Autocannon Mount");
    // array_push(_item_names, "Twin Linked Helfrost Cannon Mount");
    // array_push(_item_names, "Graviton Cannon Mount");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of land raider sponson weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_raider_regular_sponsons_item_names(_item_names) {
    array_push(_item_names, "Twin Linked Lascannon Sponsons");
    array_push(_item_names, "Hurricane Bolter Sponsons");
    array_push(_item_names, "Flamestorm Cannon Sponsons");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function returns the hard-coded list of land raider relic sponsons.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_raider_relic_sponsons_item_names(_item_names) {
    array_push(_item_names, "Quad Linked Heavy Bolter Sponsons");
    array_push(_item_names, "Twin Linked Heavy Flamer Sponsons");
    array_push(_item_names, "Twin Linked Multi-Melta Sponsons");
    array_push(_item_names, "Twin Linked Volkite Culverin Sponsons");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of land raider pintle weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_raider_pintle_item_names(_item_names) {
    array_push(_item_names, "Bolter");
    array_push(_item_names, "Combiflamer");
    array_push(_item_names, "Twin Linked Bolters");
    array_push(_item_names, "Storm Bolter");
    array_push(_item_names, "HK Missile");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of rhino weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_rhino_weapons_item_names(_item_names) {
    array_push(_item_names, "Bolter");
    array_push(_item_names, "Combiflamer");
    array_push(_item_names, "Twin Linked Bolters");
    array_push(_item_names, "Storm Bolter");
    array_push(_item_names, "HK Missile");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of predator turret weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_predator_turret_item_names(_item_names) {
    array_push(_item_names, "Autocannon Turret");
    array_push(_item_names, "Twin Linked Lascannon Turret");
    array_push(_item_names, "Flamestorm Cannon Turret");
    array_push(_item_names, "Twin Linked Assault Cannon Turret");
    array_push(_item_names, "Magna-Melta Turret");
    array_push(_item_names, "Plasma Destroyer Turret");
    array_push(_item_names, "Heavy Conversion Beam Projector");
    array_push(_item_names, "Neutron Blaster Turret");
    array_push(_item_names, "Volkite Saker Turret");
    // array_push(item_names, "Graviton Cannon Turret");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of predator sponson weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_predator_sponsons_item_names(_item_names) {
    array_push(_item_names, "Heavy Bolter Sponsons");
    array_push(_item_names, "Lascannon Sponsons");
    array_push(_item_names, "Heavy Flamer Sponsons");
    array_push(_item_names, "Volkite Culverin Sponsons");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of predator pintle weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_predator_pintle_item_names(_item_names) {
    array_push(_item_names, "Bolter");
    array_push(_item_names, "Combiflamer");
    array_push(_item_names, "Twin Linked Bolters");
    array_push(_item_names, "Storm Bolter");
    array_push(_item_names, "HK Missile");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of land speeder primary weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_speeder_primary_item_names(_item_names) {
    array_push(_item_names, "Multi-Melta");
    array_push(_item_names, "Heavy Bolter");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of land speeder secondary weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_land_speeder_secondary_item_names(_item_names) {
    array_push(_item_names, "Assault Cannon");
    array_push(_item_names, "Heavy Flamer");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of whirlwind missiles to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_whirlwind_missiles_item_names(_item_names) {
    array_push(_item_names, "Whirlwind Missiles");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of whirlwind pintle weapons to the given list.
/// @param {array} _item_names - The list to append to.
/// @returns {array} The appended list.
function push_whirlwind_pintle_item_names(_item_names) {
    array_push(_item_names, "Bolter");
    array_push(_item_names, "Combiflamer");
    array_push(_item_names, "Twin Linked Bolters");
    array_push(_item_names, "Storm Bolter");
    array_push(_item_names, "HK Missile");
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of tank upgrade items to the given list.
/// @param {array} _item_names - The list to append to.
/// @param {bool} _is_land_raider - Whether the tank is a land raider.
/// @returns {array} The appended list.
function push_tank_upgrade_item_names(_item_names, _is_land_raider=false) {
    array_push(_item_names, "Armoured Ceramite");
    array_push(_item_names, "Artificer Hull");
    array_push(_item_names, "Heavy Armour");
    if (_is_land_raider) {
        array_push(_item_names, "Void Shield");
    }
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description This function appends the list of tank accessory items to the given list.
/// @param {array} _item_names - The list to append to.
/// @param {bool} _is_land_raider - Whether the tank is a land raider.
/// @param {bool} _is_dreadnought - Whether the 'tank' is a dreadnought.
/// @returns {array} The appended list.
function push_tank_accessory_item_names(_item_names, _is_land_raider=false, _is_dreadnought=false) {
    if (!_is_dreadnought) {
        array_push(_item_names, "Dozer Blades");
    }
    array_push(_item_names, "Searchlight");
    array_push(_item_names, "Smoke Launchers");
    array_push(_item_names, "Frag Assault Launchers");
    if (!_is_land_raider && !_is_dreadnought) {
        array_push(_item_names, "Lucifer Pattern Engine");
    }
    // future: not needed when we stop using GML's deprecated Copy-on-Write behavior
    return _item_names;
}

/// @description Returns a list of equipment names filtered by given criteria.
/// @param {string} _equip_category - The category of equipment ("weapon", "armour", "gear", "mobility").
/// @param {bool} _melee_or_ranged - Whether the equipment is melee or ranged. true for melee, false for ranged.
/// @param {bool} _is_master_crafted - Whether to include only master-crafted items.
/// @param {array} _required_tags - Tags that the equipment must have.
/// @param {array} _excluded_tags - Tags that the equipment must not have.
/// @param {bool} _with_none - Include "(None)" in the list.
/// @param {bool} _with_any - Include "(any)" in the list.
/// @returns {array} item_names - The filtered list of equipment names.
function get_filtered_equipment_item_names(_equip_category, _melee_or_ranged, _is_master_crafted=false, _required_tags=undefined, _excluded_tags=undefined, _with_none=false, _with_any=false) {
    var _item_names = get_none_or_any_item_names(_with_none, _with_any);
    for (var _i = 0; _i < array_length(obj_ini.equipment); _i++) {
        if (_is_master_crafted && !array_contains(obj_ini.equipment_quality[_i], "master_crafted")) {
            continue;
        }
        var equip_data = gear_weapon_data(_equip_category, obj_ini.equipment[_i]);
        if (is_struct(equip_data) && obj_ini.equipment_number[_i] > 0) {
            if (_melee_or_ranged != undefined) {
                if (_melee_or_ranged && equip_data.range > 1.1) {
                    continue;
                } else if (!_melee_or_ranged && equip_data.range <= 1.1) {
                    continue;
                }
            }
			var valid = true;
            if (_required_tags != undefined) {
                for (var _t = 0; _t < array_length(_required_tags); _i++) {
                    if (!equip_data.has_tag(_required_tags[_t])) {
                        valid = false;
                        break;
                    }
                }
            }
            if (_excluded_tags != undefined) {
                for (var _t = 0; _t < array_length(_excluded_tags); _i++) {
                    if (equip_data.has_tag(_excluded_tags[_t])) {
                        valid = false;
                        break;
                    }
                }
            }
			if (valid) {
				array_push(_item_names, equip_data.name);
			}
        }
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
    Dreadnought = 6,
    LandRaider = 50,
    Rhino = 51,
    Predator = 52,
    LandSpeeder = 53,
    Whirlwind = 54
}

// slot names differ by unit type then equipment type
global.slot_names = {
    "1": { // Infantry
        "1": "Left Hand",
        "2": "Right Hand",
        "3": "Armour",
        "4": "Gear",
        "5": "Mobility"
    },
    "6": { // Dreadnought
        "1": "Left Arm",
        "2": "Right Arm",
        "5": "Accessory"
    },
    "50": { // Land Raider
        "1": "Front",
        "2": "Sponson",
        "3": "Pintle",
        "4": "Upgrade",
        "5": "Accessory"
    },
    "51": { // Rhino
        "1": "Weapon",
        "4": "Upgrade",
        "5": "Accessory"
    },
    "52": { // Predator
        "1": "Turret",
        "2": "Sponsons",
        "3": "Pintle",
        "4": "Upgrade",
        "5": "Accessory"
    },
    "53": { // Land Speeder
        "1": "Primary",
        "2": "Secondary"
    },
    "54": { // Whirlwind
        "1": "Missiles",
        "2": "Pintle",
        "4": "Upgrade",
        "5": "Accessory"
    }
};

/// @description This function returns the name of the slot for a given unit type and equipment type.
/// @param {real} _unit_type - The type of unit to equip, see eUNIT_TYPE.
/// @param {real} _equipment_type - The type of equipment to equip, see eEQUIPMENT_TYPE.
/// @returns {string} The name of the slot.
function get_slot_name(_unit_type, _equipment_type) {
    var _unit_key = string(_unit_type);
    var _equip_key = string(_equipment_type);

    if (global.slot_names[_unit_key] && global.slot_names[_unit_key][_equip_key]) {
        return global.slot_names[_unit_key][_equip_key];
    }
    return "Unknown";
}

/// @description This function is used to populate the weapon/equipment selection list in the equipment screen.
/// @param {real} _equipment_type - The type of equipment to equip, see eEQUIPMENT_TYPE.
/// @param {real} _equipment_subtype - The subtype of equipment to equip, see eEQUIPMENT_SUBTYPE.
/// @param {real} _unit_type - The type of unit to equip, see eUNIT_TYPE.
/// @param {bool} _include_company_standard - Whether to include the Company Standard in the selection list.
/// @param {bool} _show_available_only - Whether to limit the selection to what is in inventory, or show all items.
/// @param {bool} _master_crafted_only - Whether to show only master crafted items, or hide them.
/// @returns {array} The list of items to populate the selection list with.
function scr_get_item_names(_equipment_type, _equipment_subtype, _unit_type, _include_company_standard=false, _show_available_only=false, _master_crafted_only=false) {
    var _item_names;
    switch(_unit_type) {
        case eUNIT_TYPE.Infantry:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) {
                        if (_show_available_only) {
                            _item_names = get_filtered_equipment_item_names(
                                "weapon",
                                false, // ranged
                                _master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                true, // with_none
                                true  // with_any
                            );
                        } else {
                            _item_names = get_none_or_any_item_names(true, false);
                            _item_names = push_marine_ranged_weapons_item_names(_item_names);
                        }
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) {
                        if (_show_available_only) {
                            _item_names = get_filtered_equipment_item_names(
                                "weapon",
                                true, // melee
                                _master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                true, // with_none
                                true // with_any
                            );
                            if (_include_company_standard) {
                                array_push(_item_names, "Company Standard");
                            }
                        } else {
                            _item_names = get_none_or_any_item_names(true, false);
                            _item_names = push_marine_melee_weapons_item_names(_item_names);
                        }
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for infantry", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.Armour:
                    if (_show_available_only) {
                        _item_names = get_filtered_equipment_item_names(
                            "armour",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle armour
                            true, // with_none
                            true // with_any
                        );
                    } else {
                        _item_names = get_none_or_any_item_names(true, false);
                        _item_names = push_marine_armour_item_names(_item_names);
                    }
                    break;
                case eEQUIPMENT_TYPE.GearUpgrade:
                    if (_show_available_only) {
                        _item_names = get_filtered_equipment_item_names(
                            "gear",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle gear
                            true, // with_none
                            true // with_any
                        );
                    } else {
                        _item_names = get_none_or_any_item_names(true, false);
                        _item_names = push_marine_gear_item_names(_item_names);
                    }
                    break;
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    if (_show_available_only) {
                        _item_names = get_filtered_equipment_item_names(
                            "mobility",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle mobility
                            true, // with_none
                            true // with_any
                        );
                    } else {
                        _item_names = get_none_or_any_item_names(true, false);
                        _item_names = push_marine_mobility_item_names(_item_names);
                    }
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for infantry", true);
            }        
            break;
        case eUNIT_TYPE.Dreadnought:
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) {
                        if (_show_available_only) {
                            _item_names = get_filtered_equipment_item_names(
                                "weapon",
                                false, // ranged
                                _master_crafted_only,
                                ["dreadnought"], // required tags
                                undefined, // no excluded tags
                                true, // with_none
                                true // with_any
                            );
                        } else {
                            _item_names = get_none_or_any_item_names(true, false);
                            _item_names = push_dreadnought_ranged_weapons_item_names(_item_names);
                        }
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) {
                        if (_show_available_only) {
                            _item_names = get_filtered_equipment_item_names(
                                "weapon",
                                true, // melee
                                _master_crafted_only,
                                ["dreadnought"], // required tags
                                undefined, // no excluded tags
                                true, // with_none
                                true // with_any
                            );
                        } else {
                            _item_names = get_none_or_any_item_names(true, false);
                            _item_names = push_dreadnought_melee_weapons_item_names(_item_names);
                        }
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for dreadnought", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    _item_names = get_none_or_any_item_names(true, false);
                    _item_names = push_tank_accessory_item_names(_item_names, false, true);
                    break;
                case eEQUIPMENT_TYPE.Armour:
                case eEQUIPMENT_TYPE.GearUpgrade:
                    // Dreadnought doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for dreadnought", true);
            }
            break;
        case eUNIT_TYPE.LandRaider:
            _item_names = get_none_or_any_item_names(true, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) { // Regular land raider weapons
                        _item_names = push_land_raider_front_weapons_item_names(_item_names);
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) { // Relic land raider weapons
                        _item_names = push_land_raider_relic_front_weapons_item_names(_item_names);
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for land raider", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) { // Regular land raider weapons
                        _item_names = push_land_raider_regular_sponsons_item_names(_item_names);
                    } else if (_equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) { // Relic land raider weapons
                        _item_names = push_land_raider_relic_sponsons_item_names(_item_names);
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for land raider", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.Armour: _item_names = push_land_raider_pintle_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: _item_names = push_tank_upgrade_item_names(_item_names, true); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: _item_names = push_tank_accessory_item_names(_item_names, true, false); break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for land raider", true);
            }
            break;
        case eUNIT_TYPE.Rhino:
            _item_names = get_none_or_any_item_names(true, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: _item_names = push_rhino_weapons_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: _item_names = push_tank_upgrade_item_names(_item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: _item_names = push_tank_accessory_item_names(_item_names, false, false); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                case eEQUIPMENT_TYPE.Armour:
                    // Rhino doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for rhino", true);
            }
            break;
        case eUNIT_TYPE.Predator:
            _item_names = get_none_or_any_item_names(true, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: _item_names = push_predator_turret_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: _item_names = push_predator_sponsons_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.Armour: _item_names = push_predator_pintle_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: _item_names = push_tank_upgrade_item_names(_item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: _item_names = push_tank_accessory_item_names(_item_names, false, false); break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for predator", true);
            }
            break;
        case eUNIT_TYPE.LandSpeeder:
            _item_names = get_none_or_any_item_names(true, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: _item_names = push_land_speeder_primary_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: _item_names = push_land_speeder_secondary_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade:
                case eEQUIPMENT_TYPE.Armour:
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    // Land speeder doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for land speeder", true);
            }
            break;
        case eUNIT_TYPE.Whirlwind:
            _item_names = get_none_or_any_item_names(true, false);
            switch (_equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: _item_names = push_whirlwind_missiles_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: _item_names = push_whirlwind_pintle_item_names(_item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: _item_names = push_tank_upgrade_item_names(_item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: _item_names = push_tank_accessory_item_names(_item_names, false, false); break;
                case eEQUIPMENT_TYPE.Armour:
                    // Whirlwind doesn't have this equipment type, but an empty list is shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for whirlwind", true);
            }
            break;
    }
    return _item_names;
}
