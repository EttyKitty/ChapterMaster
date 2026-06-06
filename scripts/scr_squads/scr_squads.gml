/// @desc Fetches a squad struct from the global squads storage by its ID
/// @param {string|real} array_id The squad ID to look up
/// @returns {Struct.UnitSquad} The squad struct matching the given ID
function fetch_squad(array_id) {
    return obj_ini.squads[$ array_id];
}

/// @desc Returns an array of all squad IDs currently stored in the global squads storage
/// @returns {Array<string>} Array of squad ID strings
function get_squad_ids() {
    return struct_get_names(obj_ini.squads);
}

/// @desc Returns the total number of squads currently stored
/// @returns {real} The number of squads
function squad_count() {
    return array_length(get_squad_ids());
}

// constructor for new squad

/* okay so basically this function loops through a given company and attempts to sort the units in the company not in a squad already into 
the requested squad type , if the squad is not possible it will  not be made*/
// squad_type: the type of squad to be created as a string to access the correct key in obj_ini.squad_types
// company : the company you wish to create the squad in (int)
//squad_loadout: true if you want to use the squad loadout sorting algorithem to re-equip the squad in accordance with the squad type loadout

/*
        squad guidance
            define a role that can exist in a squad by defining 
            [<role>, {
                "max":<maximum number of this role allowed in squad>
                "min":<minimum number of this role required in squad>
                }
            ]
            by adding "loadout" as a key to the role struct e.g {"min":1,"max":1,"loadout":{}}
                a default or optional loadout can be created for the given role in the squad
            "loadout" has two possible keys "required" and "option"
            a required loadout always follows this syntax <loadout_slot>:[<loadout_item>,<required number>]
                so "wep1":["Bolter",4], will mean four marines are always equipped with 4 bolters in the wep1 slot

            option loadouts follow the following syntax <loudout_slot>:[[<loadout_item_list>],<allowed_number>]
                for example [["Flamer", "Meltagun"],1], means the role can have a max of one flamer or meltagun
                    [["Plasma Pistol","Bolt Pistol"], 4] means the role can have a mix of 4 plasma pistols and bolt pistols on top
                        of all required loadout options

    */
/// @desc Handles sorting and equipping a squad's members according to the squad type's loadout rules, pulling from and returning equipment to the armoury as needed
/// @param {Struct.UnitSquad} squad The squad to sort equipment for
/// @param {bool} from_armoury Whether equipment can be taken from the armoury
/// @param {bool} to_armoury Whether removed equipment should be returned to the armoury
function SquadEquipmentSorting(squad, from_armoury = true, to_armoury = true) constructor {
    self.target_squad = squad;
    self.from_armoury = from_armoury;
    self.to_armoury = to_armoury;
    squad_type = target_squad.type;
    squad_unit_types = squad.find_squad_unit_types();
    full_squad_data = obj_ini.squad_types[$ squad_type];
    //build a map from JSON key
    role_key_to_actual = {};
    for (var _i = 0; _i < array_length(squad_unit_types); _i++) {
    var _key = squad_unit_types[_i];
    var _def = full_squad_data[$ _key];
    var _actual = struct_exists(_def, "role") ? _def.role : _key;
    role_key_to_actual[$ _key] = _actual;
    }
    unit_role = "";
    members_UnitGroup = squad.get_members(true);
    members_UnitGroup.shuffle();
    optional_load = undefined;
    optional_fill_counts = {};   // flat struct: "slot_groupIndex" -> filled count
    required_load = undefined;
    ignore_units = [];

    target_squad.update_fulfilment();

    /// @desc Executes the full equipment sorting pass for every unit role defined in the squad type
    static sort = function() {
        for (var i = 0; i < array_length(squad_unit_types); i++) {
            unit_role = squad_unit_types[i];
            role_squad_loadout();
        }
    };

    //TODO we proobably have amcaro or soomethinng for this somewhere
    static load_out_areas = [
        "wep1",
        "wep2",
        "armour",
        "gear",
        "mobi"
    ];

    /// @desc Stores the optional loadout data and initialises per-slot fill counters for tracking how many optional items have been assigned
    /// @param {struct} optional_data The optional loadout struct from the squad type definition
    static structure_role_optional_loadout = function(optional_data) {
        // Use the original data directly — no clone needed since optional_load is now read-only
        // (all mutable state lives in optional_fill_counts). variable_clone can incorrectly
        // flatten doubly-nested arrays in this GML version, corrupting the group structure.
        optional_load = optional_data;

        // Initialise fill-count tracking in a flat struct (struct field writes are always
        // in-place in GML — no copy-on-write issues unlike nested array element writes)
        optional_fill_counts = {};
        var _optional_loadout_slots = struct_get_names(optional_load);
        for (var slot = 0; slot < array_length(_optional_loadout_slots); slot++) {
            var _load_out_slot = _optional_loadout_slots[slot];
            for (var i = 0; i < array_length(optional_load[$ _load_out_slot]); i++) {
                optional_fill_counts[$ _load_out_slot + "_" + string(i)] = 0;
            }
        }
    };

    /// @desc Processes the required loadout data for the current role, resolving "max" placeholders and inserting counters for tracking equipped quantities
    /// @param {struct} required_data The required loadout struct from the squad type definition
    static structure_role_required_loadout = function(required_data) {
        //find out if the _unit type for the squad has required  equipment thresholds

        required_load = variable_clone(required_data);
        required_loadout_slots = struct_get_names(required_load);
        for (var i = 0; i < array_length(required_loadout_slots); i++) {
            var _current_load_slot = required_loadout_slots[i];
            var _equip_slot = required_load[$ _current_load_slot];
            if (is_string(required_load[$ _current_load_slot][1])) {
                if (required_load[$ _current_load_slot][1] == "max") {
                    required_load[$ _current_load_slot][1] = target_squad.squad_fulfilment[$ unit_role];
                }
            }
            array_insert(required_load[$ _current_load_slot], 2, 0);
        }
    };

    /// @desc Equips the given unit with required equipment for the current load slot if the squad has not yet met the required quantity
    /// @param {Struct.TTRPG_stats} _unit The unit to equip
    /// @returns {bool} True if equipment was equipped, false otherwise
    static equip_required_for_role = function(_unit) {
        if (required_load[$ current_load_slot][2] < required_load[$ current_load_slot][1]) {
            //if the required amount of equipment is not in the squad already equip this marine with equipment
            var _item_to_add = required_load[$ current_load_slot][0];
            var required_load_set = {};
            required_load_set[$ current_load_slot] = _item_to_add;
            _unit.alter_equipment(required_load_set, from_armoury, to_armoury);
            required_load[$ current_load_slot][2]++;
            return true;
        } //if all required equipment is included in the squad start adding optional equipment
        return false;
    };

    /// @desc Equips the given unit with optional equipment for the current load slot, randomly selecting from available options while respecting fill limits and encumbrance checks
    /// @param {Struct.TTRPG_stats} _unit The unit to equip
    static equip_optional_for_role = function(_unit) {
        //this basically ensures the optional squad items are randomly selected and allocated in order to make squads more variable

        var _optional_groups = optional_load[$ current_load_slot];
        for (var i = 0; i < array_length(_optional_groups); i++) {
            var _count_key             = current_load_slot + "_" + string(i);
            var _optionals_filled      = optional_fill_counts[$ _count_key];   // read from flat struct
            var _optionals_max_allowed = _optional_groups[i][1];
            var _optionals_equipment   = _optional_groups[i][0];
            var _item_to_add;
            if (_optionals_filled < _optionals_max_allowed) {
                var _is_equipment_set = array_length(_optional_groups[i]) > 2;

                if (is_array(_optionals_equipment)) {
                    //if the array items are varibale e.g a struct
                    _item_to_add = array_random_element(_optionals_equipment);
                } else {
                    _item_to_add = _optionals_equipment;
                }

                // this ensures a marine never gets overloaded with an overly bulky weapon loadout
                if (current_load_slot == "wep1") {
                    var _return_item = _unit.weapon_one();
                    _unit.update_weapon_one(_item_to_add, from_armoury, to_armoury);
                    _unit.ranged_attack();
                    _unit.melee_attack();
                    if ((_unit.encumbered_ranged || _unit.encumbered_melee) && !_is_equipment_set) {
                        _unit.update_weapon_one(_return_item, from_armoury, to_armoury);
                        _unit.ranged_attack();
                        _unit.melee_attack();
                        continue;
                    }
                } else if (current_load_slot == "wep2") {
                    var _return_item = _unit.weapon_two();
                    _unit.update_weapon_two(_item_to_add, from_armoury, to_armoury);
                    _unit.ranged_attack();
                    _unit.melee_attack();
                    if ((_unit.encumbered_ranged || _unit.encumbered_melee) && !_is_equipment_set) {
                        _unit.update_weapon_two(_return_item, from_armoury, to_armoury);
                        _unit.ranged_attack();
                        _unit.melee_attack();
                        continue;
                    }
                } else {
                    var _opt_load_out = {};
                    _opt_load_out[$ current_load_slot] = _item_to_add;
                    _unit.alter_equipment(_opt_load_out, from_armoury, to_armoury);
                }

                // Struct field write — guaranteed in-place, no copy-on-write in GML
                optional_fill_counts[$ _count_key]++;
                if (_is_equipment_set) {
                    var _equip_set_data = _optional_groups[i][2];
                    if (is_struct(_equip_set_data)) {
                        _unit.alter_equipment(_equip_set_data, from_armoury, to_armoury);
                        array_push(ignore_units, _unit.uid);
                    }
                }
                break;
            }
        }
    };

    /// @desc Iterates over all members with the current unit role and equips them according to required and optional loadout rules for the current equipment slot
    static equip_loudouts_specific_equip_slot = function() {
        var _actual_role = role_key_to_actual[$ unit_role];
        var _members_with_role = members_UnitGroup.get_from({role:  _actual_role});
        if (!struct_exists(current_unit_squad_data, "loadout")) {
            return;
        }
        var _unit;
        var _loudouts = current_unit_squad_data[$ "loadout"];
        while (_members_with_role.number() > 0) {
            _unit = _members_with_role.pop();
            if (_unit.role() != _actual_role) {
                continue;
            }

            // Units that already received a full equipment set are ignored for all further loadout assignments
            if (array_contains(ignore_units, _unit.uid)) {
                continue;
            }

            if (required_load != undefined && struct_exists(required_load, current_load_slot)) {
                var _needed_required = equip_required_for_role(_unit);
                if (_needed_required) {
                    continue;
                }
            }

            if (optional_load != undefined && struct_exists(optional_load, current_load_slot)) {
                equip_optional_for_role(_unit);
            }
        }
    };

    // Picks ONE entry (loadout category) at random, then resolves each slot:
    // string values are used directly; array values get one item picked at random.
    // Any slot omitted from an entry is left unchanged on the unit.
    //
    // JSON example:
    //   "random_pick": [
    //     { "wep1": ["Sword","Axe","Mace"], "wep2": ["Pistol","Plasma","Volkite"] },
    //     { "wep1": "Lightning Claw", "wep2": "Lightning Claw" }
    //   ]

    /// @desc Picks one random loadout category from the provided options and equips all eligible squad members of the current role with the resolved equipment
    /// @param {Array<struct>} pick_options Array of loadout category structs, each defining equipment slots and possible items
    static equip_random_pick_for_role = function(pick_options) {
        var _actual_role = role_key_to_actual[$ unit_role];
        var _members_with_role = members_UnitGroup.get_from({role: _actual_role});
        while (_members_with_role.number() > 0) {
            var _unit = _members_with_role.pop();
            if (array_contains(ignore_units, _unit.uid)) continue;
            if (_unit.role() != _actual_role) continue;

            // Pick a random loadout category
            var _chosen = pick_options[irandom(array_length(pick_options) - 1)];

            // Resolve slots: array values → random element; strings → used as-is
            var _resolved = {};
            var _slots = struct_get_names(_chosen);
            for (var _s = 0; _s < array_length(_slots); _s++) {
                var _slot  = _slots[_s];
                var _value = _chosen[$ _slot];
                _resolved[$ _slot] = is_array(_value) ? array_random_element(_value) : _value;
            }
            _unit.alter_equipment(_resolved, from_armoury, to_armoury);
        }
    };

    /// @desc Processes the current unit role's loadout definition, initialising required and optional loadouts then iterating through all equipment slots to apply them
    static role_squad_loadout = function() {
        required_load = undefined;
        optional_load = undefined;

        current_unit_squad_data = full_squad_data[$ unit_role];
        if (!struct_exists(current_unit_squad_data, "loadout")) {
            return;
        }

        var _loudout_data = current_unit_squad_data[$ "loadout"];
        //find out if the _unit type for the squad has optional equipment thresholds
        if (struct_exists(_loudout_data, "option")) {
            structure_role_optional_loadout(_loudout_data[$ "option"]);
        }

        //if there are required loadout items
        if (struct_exists(_loudout_data, "required")) {
            structure_role_required_loadout(_loudout_data[$ "required"]);
        }

        for (var i = 0; i < array_length(load_out_areas); i++) {
            current_load_slot = load_out_areas[i];
            equip_loudouts_specific_equip_slot();
        }

        // random_pick runs after required/option — picks one complete loadout at random
        if (struct_exists(_loudout_data, "random_pick")) {
            equip_random_pick_for_role(_loudout_data[$ "random_pick"]);
        }
    };
}

/// @desc Creates a new squad of the given type within the specified company, initialising all squad properties and optionally sorting its equipment loadout
/// @param {string} squad_type The squad type key used to look up squad definition data
/// @param {real} company The company index this squad belongs to
function UnitSquad(squad_type = undefined, company = 0) constructor {
    members = [];
    type = "";
    squad_fulfilment = {};
    base_company = company;
    life_members = 0;
    nickname = "";
    assignment = "none";
    class = [];
    squad_leader = "";
    type_data = {};
    base = "tactical";
    formation_place = "";
    formation_options = [];
    uid = scr_uuid_generate();
    allow_bulk_swap = true;

    if (squad_type != undefined) {
        change_type(squad_type);
    }

    //TODO introduce loyalty hits from long periods of exile from hierarchy nodes
    // nodes will be captains chapter masters and other senior staff
    time_from_parent_node = 0;

    // heres where the whole thing gets annoying
    /*basically each equipment slot is looped through and inside each loop each marine is looped through in a random order to ensure 
    that each squad looks different and that each marine has a range of optional and required equipment
    required equipmetn is things like boltguns and combat knives in a tactical squad
    optional equipment is stuff like lascannons and specialist equipment in a tactical squad or plasma pistols in an assualt squad
    in future i'd like to tailer these to marine skill sets e.g the marines with the best ranged stats get given the best ranged equipment	
    */

    /// @desc Sorts the squad's equipment loadout by creating a SquadEquipmentSorting instance and executing its sort routine
    /// @param {bool} from_armoury Whether equipment can be taken from the armoury
    /// @param {bool} to_armoury Whether removed equipment should be returned to the armoury
    static sort_squad_loadout = function(from_armoury = true, to_armoury = true) {
        var _sorter = new SquadEquipmentSorting(self, from_armoury, to_armoury);
        _sorter.sort();
    };

    /// @desc Calculates the average value of the given stat across all squad members (currently unimplemented)
    /// @param {string} stat The stat name to average
    /// @returns {undefined}
    static stat_av = function(stat) {};

    /// @desc Appends additional type data to the squad, setting display name, class, base type, and formation options based on the provided data struct
    /// @param {struct} data The type data struct to apply
    static add_type_data = function(data) {
        type_data = data;
        display_name = type_data[$ "display_data"];
        if (struct_exists(type_data, "class")) {
            class = type_data.class;
        }
        if (struct_exists(type_data, "base")) {
            base = type_data.base;
        } else {
            base = "tactical";
        }
        if (struct_exists(type_data, "formation_options")) {
            formation_options = type_data.formation_options;
            formation_place = formation_options[0];
        }
    };

    /// @desc Changes the squad's type to the given type key and reloads its type data
    /// @param {string} new_type The squad type key to switch to
    static change_type = function(new_type) {
        type = new_type;
        add_type_data(obj_ini.squad_types[$ type].type_data);
    };

    /// @desc Inspects the squad type definition and returns the list of unit role keys that make up this squad, excluding the "type_data" key
    /// @returns {Array<string>} Array of unit role keys present in the squad type
    static find_squad_unit_types = function() {
        //find out what type of units squad consists of
        var fill_squad = obj_ini.squad_types[$ type];
        squad_unit_types = struct_get_names(fill_squad);
        var _wanted_unit_role;
        var unit_type_count = array_length(squad_unit_types);
        for (var i = 0; i < unit_type_count; i++) {
            _wanted_unit_role = squad_unit_types[i];
            if (_wanted_unit_role == "type_data") {
                array_delete(squad_unit_types, i, 1);
                unit_type_count--;
                i--;
                continue;
            }
            squad_fulfilment[$ _wanted_unit_role] = 0; //create a fulfilment structure to log members of squad
        }
        //Mapping for role groups in alternative source; 
        squad_role_alternatives = {};
            for (var i =0; i < array_length(squad_unit_types); i++) {
                var _role_name = squad_unit_types[i];
                var _role_def = fill_squad[$ _role_name];
                //alternative source presence check
                if (struct_exists(_role_def, "alternative_roles")) {
                    squad_role_alternatives[$ _role_name] = _role_def.alternative_roles;
                }
            }
        return squad_unit_types;
    };

    /// @desc Returns the squad's members as either an array of unit structs or a UnitGroup, filtering out any invalid members
    /// @param {bool} as_unit_group If true, returns a UnitGroup; otherwise returns an array
    /// @returns {Array<Struct.TTRPG_stats>|Struct.UnitGroup} The squad members
    static get_squad_structs = function(as_unit_group = false) {
        var _struct_array = [];
        for (var i = array_length(members) - 1; i >= 0; i--) {
            var _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                continue;
            } else {
                array_push(_struct_array, _unit);
            }
        }
        return as_unit_group ? new UnitGroup(_struct_array) : _struct_array;
    };

    // for creating a new sergeant from existing squad members
    /// @desc Promotes the most experienced squad member to sergeant, optionally targeting a veteran sergeant and a specific role
    /// @param {bool} veteran If true, promotes to veteran sergeant instead of regular sergeant
    /// @param {string|undefined} target_role Optional role key to assign to the new sergeant
    /// @returns {bool} True if a sergeant was promoted, false otherwise
    static new_sergeant = function(veteran = false, target_role = undefined) {
        var exp_unit = "";
        var _unit;
        var highest_exp = -1;
        var member_length = array_length(members);
    
        for (var i = 0; i < member_length; i++) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            }
        
            if (exp_unit == "" || _unit.experience > highest_exp) {
                highest_exp = _unit.experience;
                exp_unit = _unit;
            }
        }

        if ((array_length(members) > 0) && is_struct(exp_unit)) {
            if (exp_unit.name() != "") {
                var new_role;
                if (target_role != undefined) {
                    new_role = target_role;
                } else if (veteran == true) {
                    new_role = obj_ini.role[100][eROLE.VETERANSERGEANT];
                } else {
                    new_role = obj_ini.role[100][eROLE.SERGEANT];
                }

                exp_unit.update_role(new_role);
                if (irandom(1) == 0) {
                    exp_unit.add_trait("lead_example");
                }

                return true;
            }
        }
        return false;
    };

    /// @desc Kills all current squad members and clears the members list
    static kill_members = function() {
        for (var i = 0; i < array_length(members); i++) {
            scr_kill_unit(members[i][0], members[i][1]);
        }
        members = [];
    };

    /// @desc Cancels the squad's current assignment (currently unimplemented)
    static cancel_assignment = function() {};

    /// @desc Checks the squad's fulfilment status, optionally filling empty slots from a provided UnitIndex, and updates required, space, and fulfilment tracking structs
    /// @param {Struct.UnitIndex|undefined} fill_from Optional unit index to draw replacement members from
    static update_fulfilment = function(fill_from = undefined) {
        var _unit;

        squad_fulfilment = {};
        var fill_squad = obj_ini.squad_types[$ type]; //grab all the squad struct info from the squad_types struct

        var squad_unit_types = struct_get_names(fill_squad); //find out what type of units squad consists of
        var unit_type_count = array_length(squad_unit_types);
        // build actual_role → json_key map to handle slots with a "role" override
        var _actual_to_key = {};
        for (var i = unit_type_count - 1; i >= 0; i--) {
            var _wanted_unit_role = squad_unit_types[i];
            if (_wanted_unit_role == "type_data") {
                array_delete(squad_unit_types, i, 1);
                continue;
            }
            squad_fulfilment[$ _wanted_unit_role] = 0; //create a fulfilment structure to log members of squad
            var _role_def = fill_squad[$ _wanted_unit_role];
            var _mapped = struct_exists(_role_def, "role") ? _role_def.role : _wanted_unit_role;
            _actual_to_key[$ _mapped] = _wanted_unit_role;
        }
        var member_length = array_length(members);
        for (var i = member_length - 1; i >= 0; i--) {
            //checks squad member is still valid
            _unit = fetch_member(i);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                continue;
            }
            // map actual role to json key so role-overridden slots are counted correctly
            var _unit_role = _unit.role();
            var _slot_key = struct_exists(_actual_to_key, _unit_role) ? _actual_to_key[$ _unit_role] : _unit_role;
            if (struct_exists(squad_fulfilment, _slot_key)) {
                squad_fulfilment[$ _slot_key]++;
            } else {
                squad_fulfilment[$ _slot_key] = 1;
            }
        }
        fulfilled = true;
        required = {};
        space = {};
        has_space = false;
        for (var i = 0; i < array_length(squad_unit_types); i++) {
            var _wanted_unit_role = squad_unit_types[i];
            var _max_role_count = fill_squad[$ _wanted_unit_role][$ "max"];
            var _squad_role_current = squad_fulfilment[$ _wanted_unit_role];

            var _min_role_allowed = fill_squad[$ _wanted_unit_role][$ "min"];

            if (fill_from != undefined) {
                var _fill_role = struct_exists(fill_squad[$ _wanted_unit_role], "role")
                    ? fill_squad[$ _wanted_unit_role].role : _wanted_unit_role;
                // Also try the JSON key itself as a source role (base role before squad rename)
                var _fill_role_base = _wanted_unit_role;
                while (_squad_role_current < _max_role_count) {
                    var _pick_role = "";
                    if (fill_from.has_role(_fill_role)) {
                        _pick_role = _fill_role;
                    } else if (fill_from.has_role(_fill_role_base)) {
                        _pick_role = _fill_role_base;
                    }
                    if (_pick_role == "") break;
                    var _new_member = fill_from.pop_role_member(_pick_role);
                    add_member(_new_member.company, _new_member.marine_number);
                    squad_fulfilment[$ _wanted_unit_role]++;
                    _squad_role_current = squad_fulfilment[$ _wanted_unit_role];
                    _new_member.squad = uid;
                }
            }

            if (_squad_role_current < _max_role_count) {
                space[$ _wanted_unit_role] = _max_role_count - _squad_role_current;
                has_space = true;
            }

            if (squad_fulfilment[$ _wanted_unit_role] < _min_role_allowed) {
                fulfilled = false;
                required[$ _wanted_unit_role] = _min_role_allowed - _squad_role_current;
            }
        }
        var _default_sarge = obj_ini.role[100][eROLE.SERGEANT];
        var _default_vet_sarge = obj_ini.role[100][eROLE.VETERANSERGEANT];
        var _required_keys = struct_get_names(required);
        for (var _ri = 0; _ri < array_length(_required_keys); _ri++) {
            var _req_key = _required_keys[_ri];
            if (required[$ _req_key] <= 0) continue;
            var _role_def = fill_squad[$ _req_key];
            if (_role_def == undefined) continue;
            var _actual_role = struct_exists(_role_def, "role") ? _role_def.role : _req_key;
            if (_req_key == _default_sarge || _actual_role == _default_sarge || string_lower(_req_key) == "sergeant") {
                if (new_sergeant(false, _actual_role)) {
                    required[$ _req_key]--;
                }
            } else if (_req_key == _default_vet_sarge || _actual_role == _default_vet_sarge || string_lower(_req_key) == "veteran sergeant") {
                if (new_sergeant(true, _actual_role)) {
                    required[$ _req_key]--;
                }
            }
        }
    };

    /// @desc Removes all members from the squad, setting their squad reference to "none"
    static empty_squad = function() {
        for (var r = array_length(members) - 1; r >= 0; r--) {
            fetch_member(r).squad = "none";
        }
        members = [];
    };

    /// @desc Empties the squad and adds all former members to the provided unit index
    /// @param {Struct.UnitIndex} index The unit index to add the squad's former members to
    static empty_squad_to_index = function(index) {
        var _mems = [];
        var _mem;
        for (var r = array_length(members) - 1; r >= 0; r--) {
            _mem = fetch_member(r);
            _mem.squad = "none";
            array_push(_mems, _mem);
        }
        index.add_to_index(_mems);
        members = [];
    };

    /// @desc Returns the squad member at the given index
    /// @param {real} index The zero-based index of the member to fetch
    /// @returns {Struct.TTRPG_stats} The unit at the given index
    static fetch_member = function(index) {
        return fetch_unit(members[index]);
    };

    /// @desc Returns all current squad members, optionally wrapped in a UnitGroup
    /// @param {bool} as_UnitGroup If true, returns a UnitGroup; otherwise returns an array
    /// @returns {Array<Struct.TTRPG_stats>|Struct.UnitGroup} The squad members
    static fetch_members = function() {
        return collect_role_group("all", "", false, {"company": base_company, "squad": uid, "max_wanted": array_length(members)});
    };

    /// @desc Adds a new member to the squad using either a company/number pair or a unit struct
    /// @param {real|Struct.TTRPG_stats} comp The company index or a unit struct
    /// @param {real} unit_number The marine number within the company
    static add_member = function(comp, unit_number) {
        if (is_struct(comp)) {
            unit_number = comp.marine_number;
            comp = comp.company;
        }
        array_push(members, [comp, unit_number]);
        life_members++;
    };

    /// @desc Serialises the squad into a JSON string or plain struct, omitting methods
    /// @param {bool} stringify If true, returns a JSON string; otherwise returns a struct
    /// @returns {string|struct} The serialised squad data
    static jsonify = function(stringify = true) {
        var copy_struct = self; //grab marine structure
        var new_struct = {};
        var copy_part;
        var names = variable_struct_get_names(copy_struct); // get all keys within structure
        for (var name = 0; name < array_length(names); name++) {
            //loop through keys to find which ones are methods as they can't be saved as a json string
            if (!is_method(copy_struct[$ names[name]])) {
                copy_part = variable_clone(copy_struct[$ names[name]]);
                variable_struct_set(new_struct, names[name], copy_part); //if key value is not a method add to copy structure
            }
        }
        if (stringify) {
            return json_stringify(new_struct, true);
        } else {
            return new_struct;
        }
    };

    /// @desc Loads saved squad data from a struct, copying all non-method properties onto this squad instance
    /// @param {struct} data The saved squad data struct
    static load_json_data = function(data) {
        var names = variable_struct_get_names(data);
        for (var i = 0; i < array_length(names); i++) {
            variable_struct_set(self, names[i], variable_struct_get(data, names[i]));
        }
    };

    /// @desc Determines the relative coherency and location status of the squad based on where its members are located
    /// @returns {struct} A struct containing text, system, same_system, exact_loc, planet_side, and in_orbit fields describing squad coherency
    static squad_loci = function() {
        var member_length = array_length(members);

        if (member_length == 0) {
            return {
                text: "Empty Squad",
                system: "none",
                same_system: true,
                exact_loc: false,
                planet_side: false,
                in_orbit: false
            };
        }

        var locations = [];
        var system = "";
        var unit_loc;
        var _unit;
        var same_system = true;
        var same_loc_type = true;
        var loc_type = false;
        var same_loc_id = false;
        var loc_id;
        var in_orbit = false;
        var planet_side = false;
        var exact_loc = false;
        for (var i = 0; i < member_length; i++) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            }
            unit_loc = _unit.marine_location();
            if (system == "") {
                system = unit_loc[2];
                loc_type = unit_loc[0];
                loc_id = unit_loc[1];
            }
            if (system != unit_loc[2]) {
                same_system = false;
            }
            if (same_system) {
                if (loc_type != unit_loc[0]) {
                    same_loc_type = false;
                }
            }
            if (same_loc_type && same_system) {
                if (loc_id == unit_loc[1]) {
                    exact_loc = true;
                } else {
                    exact_loc = false;
                    if (loc_type == eLOCATION_TYPES.SHIP) {
                        in_orbit = true;
                    } else if (loc_type == eLOCATION_TYPES.PLANET) {
                        planet_side = true;
                    }
                }
            }
        }
        var final_loc_status = "";
        if (!same_system) {
            final_loc_status = "Scattered";
        } else if (same_loc_type) {
            if (loc_type == eLOCATION_TYPES.SHIP) {
                if (exact_loc) {
                    final_loc_status = $"aboard {obj_ini.ship[loc_id]}";
                } else if (in_orbit) {
                    final_loc_status = $"various ships orbiting {system}";
                }
            } else if (loc_type == eLOCATION_TYPES.PLANET) {
                if (exact_loc) {
                    final_loc_status = $"{system} {scr_roman_numerals()[loc_id - 1]}";
                } else if (planet_side) {
                    final_loc_status = $"various planets in {system}";
                }
            }
        } else {
            final_loc_status = $"system {system}";
        }
        return {text: final_loc_status, system: system, same_system: same_system, exact_loc: exact_loc, planet_side: planet_side, in_orbit: in_orbit};
        //returns all the squad coherency data
    };

    /// @desc Determines the squad leader by selecting the highest-ranking member according to role hierarchy, falling back to highest experience on ties
    /// @returns {Array<real>|string} The [company, marine_number] pair of the leader, or "none" if the squad is empty
    static determine_leader = function() {
        var _unit;
        var member_length = array_length(members);
        var hierarchy = role_hierarchy();
        var leader_hier_pos = array_length(hierarchy);
        var leader = "none";
        for (var i = 0; i < member_length; i++) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            } else {
                if (leader == "none") {
                    leader = [
                        _unit.company,
                        _unit.marine_number
                    ];
                    for (var r = 0; r < array_length(hierarchy); r++) {
                        if (hierarchy[r] == _unit.role()) {
                            leader_hier_pos = r;
                            break;
                        }
                    }
                } else if (leader_hier_pos < array_length(hierarchy) && hierarchy[leader_hier_pos] == _unit.role()) {
                    var _leader = fetch_unit(leader);
                    if (_leader.experience < _unit.experience) {
                        leader = [
                            _unit.company,
                            _unit.marine_number
                        ];
                    }
                } else {
                    for (var r = 0; r < leader_hier_pos; r++) {
                        if (hierarchy[r] == _unit.role()) {
                            leader_hier_pos = r;
                            leader = [
                                _unit.company,
                                _unit.marine_number
                            ];
                            break;
                        }
                    }
                }
            }
        }
        squad_leader = leader;
        return leader;
    };

    /// @desc Swaps the current squad sergeant with the provided new sergeant, transferring roles and adjusting loyalty
    /// @param {Struct.TTRPG_stats} new_sgt The new sergeant unit to install
    static change_sgt = function(new_sgt) {
        sgt = determine_leader();
        var remove_sgt;
        if (sgt != "none") {
            remove_sgt = fetch_unit(sgt);
            if (remove_sgt.IsSpecialist(SPECIALISTS_SQUAD_LEADERS)) {
                var replace_role = remove_sgt.role();
                remove_sgt.update_role(new_sgt.role());
                //TODO centralise loyalty changes for role changes in the update_role method
                remove_sgt.alter_loyalty(-10);
                new_sgt.update_role(replace_role);
                new_sgt.alter_loyalty(10);
            }
        }
    };

    /// @desc Sets the location of all squad members to the given system, location ID, and world ID, handling ship and planet transfers
    /// @param {string} loc The system name to move the squad to
    /// @param {real} lid The location/planet ID within the system
    /// @param {real} wid The world/body ID within the location
    /// @returns {string|void} "invalid system" if the system is not found, otherwise undefined
    static set_location = function(loc, lid, wid) {
        var member_length = array_length(members);
        var member_location;
        var system = "none";
        with (obj_star) {
            if (name == loc) {
                system = self;
                break;
            }
        }
        if (system == "none") {
            return "invalid system";
        }
        member_loop(set_member_loc, {loc: loc, lid: lid, wid: wid, system: system});
    };

    /// @desc Iterates over all squad members, calling the given member function with the provided data pack, supporting early exit via an "action":"break" response
    /// @param {function} member_func The function to call for each member
    /// @param {struct} data_pack The data struct to pass into each member function call
    /// @returns {struct} The final data pack after processing all members
    static member_loop = function(member_func, data_pack) {
        var _unit;
        member_length = array_length(members);
        for (var i = 0; i < member_length; i++) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            } else {
                var pack_return;
                with (_unit) {
                    pack_return = member_func(data_pack);
                }
                data_pack = pack_return;
                if (struct_exists(data_pack, "action")) {
                    if (data_pack.action == "break") {
                        break;
                    }
                }
            }
        }
        return data_pack;
    };

    /// @desc Returns all current squad members, optionally wrapped in a UnitGroup
    /// @param {bool} as_UnitGroup If true, returns a UnitGroup; otherwise returns an array
    /// @returns {Array<Struct.TTRPG_stats>|Struct.UnitGroup} The squad members
    static get_members = function(as_UnitGroup = false) {
        var mems = [];
        for (var i = 0; i < array_length(members); i++) {
            array_push(mems, fetch_member(i));
        }
        if (as_UnitGroup) {
            return new UnitGroup(mems);
        }
        return mems;
    };
}

/// @desc Initialises the global squads storage and organises squads across the chapter according to the chapter squad arrangement configuration
function game_start_squads() {
    obj_ini.squads = {};
    if (struct_exists(chapter_squad_arrangement, "companies")) {
        var _comp_datas = chapter_squad_arrangement.companies;
        for (var i = 0; i < array_length(_comp_datas); i++) {
            var _company = collect_company(_comp_datas[i].company);
            _company.organise_by_template(_comp_datas[i]);
        }
    }
}

/// @desc Handles moving a single marine member to a new location, managing ship unloading, planet transfers, and marine loading as needed
/// @param {struct} loc_data Data pack containing loc, lid, wid, and system information for the move
/// @returns {struct} The updated location data pack
function set_member_loc(loc_data) {
    var loc = loc_data.loc;
    var lid = loc_data.lid;
    var wid = loc_data.wid;
    var system = loc_data.system;
    var member_location = marine_location();
    if (wid > 0 && loc == member_location[2]) {
        if (member_location[0] == eLOCATION_TYPES.SHIP) {
            unload(wid, system);
        } else if (member_location[0] == eLOCATION_TYPES.PLANET && member_location[1] != wid && member_location[2] == loc) {
            get_unit_size();
            system.p_player[member_location[1]] -= size;
            system.p_player[wid] += size;
            planet_location = wid;
            ship_location = -1;
        }
    } else {
        if (wid == 0 && lid > -1) {
            load_marine(lid);
        }
    }
    return loc_data;
}
//finds all the squads linked to a given company
//TODO coalece lots of these functions to make make a company object
//maybe then we can have more than 10 companies 
