/// @desc View controller for the main management screen panels.
function ManagementView() constructor {
    panels = [];

    /// @desc Orchestrates the creation of all panels.
    static init = function() {
        with (obj_ini) {
            sort_all_companies();
        }

        with (obj_managment_panel) {
            instance_destroy();
        }

        build_company_panels();
        build_special_panels();
    };

    /// @desc Helper to spawn and track a management panel.
    static create_panel = function(_x, _y, _manage_id, _title, _header, _company_id) {
        /// @type {Asset.GMObject.obj_managment_panel}
        var _panel = instance_create_depth(_x, _y, 0, obj_managment_panel);
        _panel.company = _company_id;
        _panel.manage = _manage_id;
        _panel.header = _header;
        _panel.title = _title;
        _panel.line = _panel.line ?? [];

        array_push(panels, _panel);
        return _panel;
    };

    static get_vehicle_strings = function(_company_id, _filter = undefined) {
        var _veh_map = new CountingMap();
        var _veh_array = obj_ini.veh_role[_company_id];
        var _veh_len = array_length(_veh_array);

        for (var v = 0; v < _veh_len; v++) {
            var _veh = _veh_array[v];
            if (_veh != "") {
                if (_filter == undefined || struct_exists(_filter, _veh)) {
                    _veh_map.add(_veh);
                }
            }
        }
        return _veh_map.get_plural_strings_array();
    };

    /// @desc Builds panels for all standard companies (1 to obj_ini.companies).
    static build_company_panels = function() {
        var _xx = 25;
        var _yy = 352;

        for (var _i = 1; _i <= obj_ini.companies; _i++) {
            if (_i == 11) {
                _xx = 25;
                _yy = 610;
            }

            var _title = string_upper(scr_convert_company_to_string(_i));
            var _manage_id = (_i > 10) ? _i + 100 : _i;
            var _panel = create_panel(_xx, _yy, _manage_id, _title, 1, _i);

            var _co_units = collect_company(_i).index_roles();
            _panel.line = array_join(_panel.line, _co_units.create_plural_strings_array(), get_vehicle_strings(_i));

            _xx += 156;
        }
    };

    /// @desc Builds the HQ and specialist panels.
    static build_special_panels = function() {
        var _role_names = obj_ini.role[100];
        var _hq_index = collect_company(0).index_roles();
    
        var _hq_pane = create_panel(700, 132, 11, "HEADQUARTERS", 3, 0);
        var _hq_roles = new SetLight([
            _role_names[eROLE.CHAPTERMASTER],
            _role_names[eROLE.HONOURGUARD]
        ]);
        _hq_pane.line = array_join(_hq_index.create_plural_strings_array(true, true, true, _hq_roles.data), get_vehicle_strings(0));
    
        var _apoth_pane = create_panel(275, 132, 12, "APOTHECARIUM", 2, 0);
        var _apoth_roles = new SetLight([
            "Master of the Apothecarion",
            _role_names[eROLE.APOTHECARY],
            $"{_role_names[eROLE.APOTHECARY]} Aspirant"
        ]);
        _apoth_pane.line = _hq_index.create_plural_strings_array(true, true, true, _apoth_roles.data);
    
        var _rec_pane = create_panel(475, 132, 14, "RECLUSIUM", 2, 0);
        var _rec_roles = new SetLight([
            "Master of Sanctity",
            _role_names[eROLE.CHAPLAIN],
            $"{_role_names[eROLE.CHAPLAIN]} Aspirant"
        ]);
        _rec_pane.line = _hq_index.create_plural_strings_array(true, true, true, _rec_roles.data);
    
        var _arm_pane = create_panel(925, 132, 15, "ARMOURY", 2, 0);
        var _arm_roles = new SetLight([
            "Forge Master",
            _role_names[eROLE.TECHMARINE],
            $"{_role_names[eROLE.TECHMARINE]} Aspirant",
            "Techpriest"
        ]);
        _arm_pane.line = _hq_index.create_plural_strings_array(true, true, true, _arm_roles.data);
    
        var _lib_pane = create_panel(1125, 132, 13, "LIBRARIUM", 2, 0);
        var _lib_roles = new SetLight([
            $"Chief {_role_names[eROLE.LIBRARIAN]}",
            _role_names[eROLE.LIBRARIAN],
            "Codiciery",
            "Lexicanum",
            $"{_role_names[eROLE.LIBRARIAN]} Aspirant"
        ]);
        _lib_pane.line = _hq_index.create_plural_strings_array(true, true, true, _lib_roles.data);
    };
}
