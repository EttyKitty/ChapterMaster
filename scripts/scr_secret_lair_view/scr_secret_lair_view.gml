/// @function LairUpgradeButton(label, description, cost, field_name, field_value, x1, y1)
/// @constructor
/// @category UI
/// @description A single upgrade button in the Secret Lair build menu.
function LairUpgradeButton(_label, _desc, _cost, _field, _value, _x1, _y1) constructor {
    label = _label;
    description = _desc;
    cost = _cost;
    field_name = _field;
    field_value = _value;
    x1 = _x1;
    y1 = _y1;
    x2 = x1 + 120;
    y2 = y1 + 20;
    disabled = false;

    button = new UnitButtonObject({x1: x1, y1: y1, w: 120, h: 20, set_height_width: true, label: label, font: fnt_40k_14});

    static set_disabled = function(_disabled) {
        disabled = _disabled;
        button.disabled = _disabled;
        return self;
    };

    static draw = function(_lair_struct, _req) {
        var _clicked = button.draw(_req >= cost);

        if (scr_hit(x1, y1, x2, y2)) {
            tooltip_draw(description, 350, return_mouse_consts(), #50a076, fnt_40k_14, label, fnt_40k_14b, false, "Cost:#", fnt_40k_12, cost);
        }

        if (_clicked && !disabled && (_req >= cost)) {
            if (field_name == "relic") {
                _lair_struct[$ field_name] += field_value;
            } else {
                _lair_struct[$ field_name] = field_value;
            }

            return true;
        }

        return false;
    };
}

/// @function LairView(target_planet, planet_index)
/// @constructor
/// @category UI
/// @description Manages the entire Secret Lair UI, state, and rendering.
/// @param {Asset.GMObject.obj_star} _star
function LairView(_star, _planet_index) constructor {
    star = _star;
    planet_index = _planet_index;

    x_base = camera_get_view_x(view_camera[0]) + 25;
    y_base = camera_get_view_y(view_camera[0]) + 165;

    /// @type {Array<Struct.LairUpgradeButton>}
    upgrade_buttons = [];

    upgrades = undefined;
    /// @type {Struct.NewPlanetFeature|undefined}
    secret_base = undefined;
    has_arsenal = false;
    has_gene_vault = false;
    lair_exists = false;

    btn_back = new UnitButtonObject({
        label: "Back",
        font: fnt_40k_30b,
        set_height_width: true,
        w: 120,
        h: 32,
        bind_method: function() {
            obj_controller.menu = 0;
            obj_controller.lair_view = undefined;
        },
    });

    build_buttons = [];

    static build_options = [
        {
            title: "Lair",
            y_off: 45,
            cost: 1000,
            desc: "Customizable hideout that your forces may garrison into.  The Lair may be upgraded further.",
            is_new: true,
            feature: undefined,
        },
        {
            title: "Arsenal",
            y_off: 110,
            cost: 1500,
            desc: "Hidden armoury that stores unused Chaos and Daemonic artifacts, preventing them from discovery.",
            is_new: false,
            feature: eP_FEATURES.ARSENAL,
        },
        {
            title: "Gene-Vault",
            y_off: 175,
            cost: 4000,
            desc: "Hidden gene-vault that off-sources the majority of your Gene-Seed and Test-Slave Incubators.",
            is_new: false,
            feature: eP_FEATURES.GENE_VAULT,
        },
    ];

    static lair_upgrades = [
        {
            label: "Forge",
            desc: "A modest, less elaborate forge able to employ a handful of Astartes or Techpriest.",
            cost: 1000,
            field: "forge",
            value: true,
            flavor_text: " Your lair has a forge, fit to be used by several astartes at once. ",
        },
        {
            label: "Hippodrome",
            desc: "A moderate sized garage fit to hold, service, and display vehicles.",
            cost: 1000,
            field: "hippo",
            value: true,
            flavor_text: " Your lair has a hippodrome, or garage, that holds luxury vehicles. ",
        },
        {
            label: "Beastarium",
            desc: "An enclosure with simulated greenery and foilage meant to hold beasts.",
            cost: 1000,
            field: "beastarium",
            value: true,
            flavor_text: " Your lair has a beastarium, animals native to your homeworld living within. ",
        },
        {
            label: "Torture Chamber",
            desc: "Only the best for the best.  A room full of torture tools and devices.",
            cost: 500,
            field: "torture",
            value: true,
            flavor_text: " One of the rooms is a well-stocked torture chamber. ",
        },
        {
            label: "Narcotics",
            desc: "Several boxes worth of Obscura, Black Lethe, Kyxa... line it up.",
            cost: 500,
            field: "narcotics",
            value: true,
            flavor_text: " Many of the tables have lines of white powder set on paper or bunches of needles.  Plastic straws lay close by. ",
        },
        {
            label: "Relic Room",
            desc: "A room meant for displaying trophies.  May be purchased successive times.",
            cost: 500,
            field: "relic",
            value: 1,
            flavor_text: "", // Handled dynamically via stock
        },
        {
            label: "Cookery",
            desc: "A larger, well-stocked cookery, complete with a number of Imperial Chef servants.",
            cost: 250,
            field: "cookery",
            value: true,
            flavor_text: "", // Handled dynamically based on player presence
        },
        {
            label: "Vox Casters",
            desc: "All the bass one could ever imaginably need.",
            cost: 250,
            field: "vox",
            value: true,
            flavor_text: "", // Handled dynamically based on player presence
        },
        {
            label: "Librarium",
            desc: "A study fit to hold a staggering amount of tomes and scrolls.",
            cost: 250,
            field: "librarium",
            value: true,
            flavor_text: " A large librarium makes up one of the wings, holding countless novels, books, scrolls, and documents on various topics. ",
        },
        {
            label: "Throne",
            desc: "A massive, ego boosting throne.",
            cost: 250,
            field: "throne",
            value: true,
            flavor_text: "", // Handled dynamically based on player presence
        },
        {
            label: "Stasis Pods",
            desc: "Though they start empty, you may capture and display your foes in these.",
            cost: 200,
            field: "stasis",
            value: true,
            flavor_text: " One of the chambers holds several stasis pods for display.  They are currently empty. ",
        },
        {
            label: "Swimming Pool",
            desc: "A large body of water meant for excersize or relaxation.",
            cost: 100,
            field: "swimming",
            value: true,
            flavor_text: " A large swimming pool with chapter-themed floaties is emplaced near the entrance. ",
        },
    ];

    static style_descriptions = {
        BRB: ", the walls decorated with animal hides and leather.  Among the copius body-trophies and bones are torches that hiss and spit. ",
        DIS: "- the main attraction is the rainbow-colored, lit up grid flooring which quickly change color.  Far overhead are metal rafters. ",
        FEU: ", the walls made up of sturdy blocks of stones.  It is heavily decorated with wooden furniture, banners, and medieval weaponry. ",
        GTH: ", the walls made up of lightly-dusty stone.  Mosaics and statues are abundant throughout, giving it that comfortable gothic feel. ",
        MCH: "- at a glance it appears decorated like a factory.  Those with a neural network see the lair as brightly colored and lit, full of knowledge, learning, and chapter iconography. ",
        PRS: ", the walls made up of polished sandstone or marble.  All throughout are chapter iconography and ancient symbols, wrought in gold. ",
        RAV: " but nearly pitch-black inside.  The only illumination is provided by loopy neon lux-casters, and strobes, which blast out light in random, flickering patterns. ",
        STL: ".  All of the surfaces are made up of highly polished stainless steel.  An occasional small water fountain or plant decorates the place. ",
        UTL: " and almost civilian looking in nature- the walls are up of simple concrete or plaster.  A thick carpet covers much of the floor.",
    };

    static lair_feature_descriptions = {
        arsenal_hidden: "A moderate sized secret Arsenal, this structure has ample holding area to store any number of artifacts and wargear.  Chaos and Daemonic items will be sent here by your Master of Relics, and due to the secret nature of its existance, the Inquisition will not find them during routine inspections.",
        arsenal_discovered: "A moderate sized Arsenal, this structure has ample holding area to store any number of artifacts and wargear.  Since being discovered it may no longer hide Chaos and Daemonic wargear from routine Inquisition inspections.  You may wish to construct another Arsenal on a different planet.",
        vault_hidden: "A large facility with Gene-Vaults and additional spare rooms, this structure safely stores the majority of your Gene-Seed and is ran by servitors.  Due to its secret nature you may amass Gene-Seed and Test-Slave Incubators without fear of Inquisition reprisal or taking offense.",
        vault_discovered: "A large facility with Gene-Vaults and additional spare rooms, this structure safely stores the majority of your Gene-Seed and is ran by servitors.  Since being discovered all the contents are known to the Inquisition.  Your Gene-Seed remains protected but you may wish to build a new, secret one.",
    };

    // METHODS

    static draw = function() {
        _update_state();

        add_draw_return_values();
        draw_sprite(spr_popup_large, 1, x_base, y_base);

        _draw_header();

        if (obj_temp_build.isnew) {
            _draw_style_selector();
        } else {
            if (secret_base != undefined) {
                if (secret_base.built > obj_controller.turn) {
                    draw_set_font(fnt_40k_14b);
                    draw_set_halign(fa_left);
                    draw_text(x_base + 21, y_base + 65, $"This feature will be constructed in {secret_base.built - obj_controller.turn} months.");
                } else {
                    _draw_lair_description();
                    _process_upgrade_buttons();
                }
            }

            _draw_feature_descriptions();

            if (!lair_exists) {
                _draw_build_menu();
            }
        }

        _draw_back_button();
        pop_draw_return_values();
    };

    static _update_state = function() {
        upgrades = star.p_upgrades[planet_index];

        var _base_idx = search_planet_features(upgrades, eP_FEATURES.SECRET_BASE);
        secret_base = (array_length(_base_idx) > 0) ? upgrades[_base_idx[0]] : undefined;

        has_arsenal = planet_feature_bool(upgrades, eP_FEATURES.ARSENAL);
        has_gene_vault = planet_feature_bool(upgrades, eP_FEATURES.GENE_VAULT);
        lair_exists = (secret_base != undefined) || has_arsenal || has_gene_vault;

        if (secret_base != undefined && secret_base.built <= obj_controller.turn && array_length(upgrade_buttons) == 0) {
            _init_buttons();
        }

        if (array_length(build_buttons) == 0) {
            for (var i = 0; i < array_length(build_options); i++) {
                array_push(build_buttons, new UnitButtonObject({label: "Build", set_height_width: true, w: 100, h: 20}));
            }
        }
    };

    static _init_buttons = function() {
        var _btn_x = x_base + 494;
        for (var i = 0; i < array_length(lair_upgrades); i++) {
            var _upg = lair_upgrades[i];
            var _btn_y = y_base + 12 + (i * 22);
            var _disabled = (_upg.field == "relic") ? (secret_base.relic > 0) : secret_base[$ _upg.field];

            var _btn = new LairUpgradeButton(_upg.label, _upg.desc, _upg.cost, _upg.field, _upg.value, _btn_x, _btn_y);
            _btn.set_disabled(_disabled);
            array_push(upgrade_buttons, _btn);
        }
    };

    static _draw_header = function() {
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);

        var _title = "Build ";
        if (secret_base != undefined) {
            _title = "Secret Lair ";
        } else if (has_arsenal) {
            _title = "Secret Arsenal ";
        } else if (has_gene_vault) {
            _title = "Secret Gene-Vault ";
        }

        _title += "(" + string(star.name) + " " + scr_roman(planet_index) + ")";
        draw_text_transformed(x_base + 312, y_base + 10, _title, 0.7, 0.7, 0);
    };

    static _draw_style_selector = function() {
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_center);
        draw_text(x_base + 312, y_base + 45, "Select a Secret Lair style.");
        draw_set_halign(fa_left);

        var _bx1 = x_base + 21, _bx2 = _bx1 + 579;
        var _tx1 = _bx1 + 2, _tx2 = _tx1 + 100;

        for (var r = 0; r < array_length(obj_controller.lair_styles); r++) {
            var _style = obj_controller.lair_styles[r];
            var _by1 = y_base + 88 + (r * 30);
            var _by2 = _by1 + 18;

            draw_set_color(c_gray);
            draw_rectangle(_bx1, _by1, _bx2, _by2, 0);

            if (scr_hit(_bx1, _by1, _bx2, _by2)) {
                draw_set_color(c_black);
                draw_set_alpha(0.2);
                draw_rectangle(_bx1, _by1, _bx2, _by2, 0);
                draw_set_alpha(1);

                if (mouse_button_clicked()) {
                    obj_temp_build.isnew = false;
                    array_push(upgrades, new NewPlanetFeature(eP_FEATURES.SECRET_BASE, {style: _style.tag}));
                }
            }

            draw_set_color(c_black);
            draw_set_font(fnt_40k_14b);
            draw_text_transformed(_tx1, _by1 + 2, _style.name, 1, 0.8, 0);
            draw_set_font(fnt_40k_14);
            draw_text_transformed(_tx2, _by1 + 2, _style.description, 1, 0.8, 0);
        }
    };

    static _draw_lair_description = function() {
        var _desc = "Deep beneath the surface of " + string(star.name) + " " + scr_roman(planet_index) + " lays your ";
        _desc += (secret_base.inquis_hidden == 1) ? "secret lair. " : "previously discovered lair. ";
        _desc += "It is massive" + _get_style_desc(secret_base.style);

        var _players_present = star.p_player[planet_index] > 0;

        if (secret_base.throne) {
            _desc += " The center chamber is dominated by a massive throne, ";
            _desc += (obj_controller.temp[104] == $"{star.name}.{planet_index}") ? "which you are currently seated upon. " : "though it is currently vacant. ";
        }

        if (secret_base.vox && _players_present) {
            _desc += "Heretical music blasts from the vox-casters, shaking the walls. ";
        }

        if (secret_base.cookery) {
            _desc += _players_present ? "Imperial Chefs are currently bustling to and from the kitchen, cooking savory treats and food for those present. " : "The Imperial Chefs are mostly idle, making use of the other rooms and facilities. ";
        }

        _desc += _get_stock_desc(secret_base.stock);

        for (var i = 0; i < array_length(lair_upgrades); i++) {
            var _upg = lair_upgrades[i];
            if (_upg.flavor_text != "" && secret_base[$ _upg.field]) {
                _desc += _upg.flavor_text;
            }
        }

        var _bx1 = x_base + 12, _by1 = y_base + 45;
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_rectangle(_bx1, _by1, x_base + 486, y_base + 378, 1);

        var _hh = 1;
        for (var i = 0; i < 2; i++) {
            if ((string_height_ext(_desc, -1, 470) * _hh) > 330) {
                _hh -= 0.1;
            }
        }

        draw_text_ext_transformed(_bx1 + 2, _by1 + 2, _desc, -1, 470 * (2 + (_hh * -1)), _hh, _hh, 0);
    };

    static _draw_feature_descriptions = function() {
        var _desc = "";
        if (has_arsenal) {
            _desc = _get_feature_desc(eP_FEATURES.ARSENAL);
        }

        if (has_gene_vault) {
            _desc = _get_feature_desc(eP_FEATURES.GENE_VAULT);
        }

        if (_desc != "") {
            draw_set_halign(fa_left);
            draw_set_font(fnt_40k_14);
            draw_set_color(c_gray);
            draw_text_ext(x_base + 21, y_base + 65, _desc, -1, 595);
        }
    };

    static _draw_build_menu = function() {
        for (var i = 0; i < array_length(build_options); i++) {
            var _opt = build_options[i];

            _draw_build_option(
                _opt.title,
                _opt.y_off,
                _opt.cost,
                _opt.desc,
                build_buttons[i],
                function(_is_new, _feat) {
                    if (_is_new) {
                        obj_temp_build.isnew = true;
                    } else {
                        array_push(upgrades, new NewPlanetFeature(_feat));
                    }
                },
                _opt.is_new,
                _opt.feature,
            );
        }
    };

    /// @param {Struct.UnitButtonObject} _btn_struct
    static _draw_build_option = function(_title, _y_off, _cost, _desc, _btn_struct, _on_click, _is_new, _feat) {
        var _by = y_base + _y_off;

        draw_set_font(fnt_40k_14b);
        draw_set_color(c_gray);
        draw_set_halign(fa_left);
        draw_text(x_base + 21, _by, _title);

        draw_set_font(fnt_40k_14);
        draw_sprite(spr_requisition, 0, x_base + 160, _by + 2);
        draw_set_color((obj_controller.requisition < _cost) ? c_red : #F89823);
        draw_text(x_base + 180, _by + 2, string(_cost));

        draw_set_color(c_gray);
        draw_text_ext(x_base + 21, _by + 20, _desc, -1, 600);

        _btn_struct.update({x1: x_base + 300, y1: _by});
        if (_btn_struct.draw(obj_controller.requisition >= _cost)) {
            obj_controller.requisition -= _cost;
            _on_click(_is_new, _feat);
        }
    };

    static _process_upgrade_buttons = function() {
        for (var i = 0; i < array_length(upgrade_buttons); i++) {
            var _btn = upgrade_buttons[i];

            if (_btn.draw(secret_base, obj_controller.requisition)) {
                obj_controller.requisition -= _btn.cost;
                _btn.set_disabled(true);
            }
        }
    };

    static _draw_back_button = function() {
        btn_back.update({x1: x_base + 252, y1: y_base + 388});
        btn_back.draw();
    };

    // --- LOOKUP HELPERS ---
    static _get_style_desc = function(_tag) {
        return style_descriptions[$ _tag] ?? "";
    };

    static _get_stock_desc = function(_level) {
        if (_level >= 30) {
            return " Gold and gems are EVERYWHERE.  The main chamber in particular is a sea of gold and gems, especially deep at the corners.  In all it is nearly three feet deep.  Coins clink and settle as your forces walk through the room. ";
        }

        if (_level >= 25) {
            return " Gold and gems are everywhere, occasionally attached to the walls and ceiling where able. ";
        }

        if (_level >= 21) {
            return " Your abundant wealth is evident in your lair- every surface and much of the floor smothered by gold or gems. ";
        }

        if (_level >= 19) {
            return " Much of your lair is carelessly covered in gold coins, objects, and gems. ";
        }

        if (_level >= 17) {
            return " The abundant gold and gems spill out into the hallway, your forces idly stepping across it. ";
        }

        if (_level >= 15) {
            return " War trophies, chests of gold, precious gems, your lair has it all, and in abundance. ";
        }

        if (_level >= 12) {
            return " In addition to the many war trophies your Relic Room also has sizeable piles of gold. ";
        }

        if (_level >= 10) {
            return " In addition to the many war trophies your Relic Room also has small amounts of gold coins. ";
        }

        if (_level >= 8) {
            return " Your Relic Room's trophies, skulls, and armours now spill out into the hallways, such is their number. ";
        }

        if (_level >= 6) {
            return " Your Relic Room contains wargear and suits of armour from all races, several Adeptus Astartes suits included. ";
        }

        if (_level >= 3) {
            return " Your Relic Room contains trophies and skulls, taken from every Xeno race. ";
        }

        if (_level >= 1) {
            return " One of the chambers is hollowed out to display war trophies and gear. ";
        }

        return "";
    };

    static _get_feature_desc = function(_feature_type) {
        var _idx = search_planet_features(upgrades, _feature_type);
        if (array_length(_idx) == 0) {
            return "";
        }

        /// @type {Struct.NewPlanetFeature}
        var _feat = upgrades[_idx[0]];
        var _key = (_feature_type == eP_FEATURES.ARSENAL) ? "arsenal" : "vault";
        _key += (_feat.inquis_hidden == 1) ? "_hidden" : "_discovered";

        return lair_feature_descriptions[$ _key] ?? "";
    };
}
