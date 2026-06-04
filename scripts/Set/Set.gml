function Set(_array = []) constructor {
    data = ds_map_create();

    for (var i = 0, l = array_length(_array); i < l; i++) {
        ds_map_add(data, _array[i], true);
    }

    static add = function(_key) {
        ds_map_add(data, _key, true);
        return self;
    };

    static remove = function(_key) {
        var existed = ds_map_exists(data, _key);
        ds_map_delete(data, _key);
        return existed;
    };

    static clear = function() {
        ds_map_clear(data);
        return self;
    };

    static has = function(_key) {
        return ds_map_exists(data, _key);
    };

    static foreach = function(_callback) {
        var _keys = keys();
        for (var i = 0, l = array_length(_keys); i < l; i++) {
            var _key = _keys[i];
            _callback(_key);
        }
        return self;
    };

    static size = function() {
        return ds_map_size(data);
    };

    static empty = function() {
        return ds_map_empty(data);
    };

    static keys = function() {
        return ds_map_keys_to_array(data);
    };

    static destroy = function() {
        ds_map_destroy(data);
        data = -1;
        return self;
    };
}

function SetLight(_array = []) constructor {
    data = {};
    _size = 0;

    static _exists = function(_key) {
        return struct_exists(data, _key);
    };

    static add = function(_key) {
        if (!_exists(_key)) {
            data[$ _key] = true;
            _size++;
        }
        return self;
    };

    static remove = function(_key) {
        var existed = _exists(_key);
        if (existed) {
            struct_remove(data, _key);
            _size--;
        }
        return existed;
    };

    static clear = function() {
        data = {};
        _size = 0;
        return self;
    };

    static has = function(_key) {
        return _exists(_key);
    };

    static foreach = function(_callback) {
        var _keys = keys();
        for (var i = 0, l = array_length(_keys); i < l; i++) {
            _callback(_keys[i]);
        }
        return self;
    };

    static size = function() {
        return _size;
    };

    static empty = function() {
        return _size == 0;
    };

    static keys = function() {
        return struct_get_names(data);
    };

    static destroy = function() {
        data = undefined;
        _size = 0;
        return self;
    };

    for (var i = 0, l = array_length(_array); i < l; i++) {
        add(_array[i]);
    }
}
