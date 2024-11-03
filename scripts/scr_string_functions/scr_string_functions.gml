/// @function string_upper_first
/// @description Capitalizes the first character in a string.
/// @param {string} _string The string to be modified.
/// @returns {string} Modified string.

function string_upper_first(_string) {
    try {
        var _first_char;
        var _modified_string;
    
        _first_char = string_char_at(_string, 1);
        _first_char = string_upper( _first_char );
        
        _modified_string = _string;
        _modified_string = string_delete(_modified_string, 1, 1);
        _modified_string = string_insert(_first_char, _modified_string, 1);
    
        return _modified_string;
	}
    catch(_exception) {
		log_into_file(_exception.longMessage);
		log_into_file(_exception.script);
		log_into_file(_exception.stacktrace);
        show_debug_message(_exception.longMessage);
	}
}

/// @function string_plural
/// @description This function formats a string into a plural form by adding affixes following common rules.
function string_plural(_string, _variable = 2) {
    if (_variable < 2) {
        return _string;
    }

    var _last_char = string_char_at(_string, string_length(_string));
    var _last_two_chars = string_copy(_string, string_length(_string) - 1, 2);
    if (_last_char == "y") {
        return string_copy(_string, 1, string_length(_string) - 1) + "ies";
    }
    else if (array_contains(["s", "x", "z", "ch", "sh"], _last_char)) {
        return _string + "es";
    }
    else if (_last_char == "f" || _last_two_chars == "fe") {
        return string_copy(_string, 1, string_length(_string) - string_length(_last_two_chars)) + "ves";
    }
    else {
        return _string + "s";
    }
}

/// @function string_truncate
/// @description Truncates a string to fit within a specified pixel width, appending "..." if the string was truncated.
/// @param {string} _text The string to be truncated.
/// @param {int} _max_width The maximum allowable pixel width for the string.
/// @returns {string} Original or truncated string.
function string_truncate(_text, _max_width) {
    var _ellipsis = "...";
    var _ellipsis_width = string_width(_ellipsis);
    var _text_width = string_width(_text);
    if (_text_width > _max_width) {
        var i = string_length(_text);
        while (_text_width + _ellipsis_width > _max_width && i > 0) {
            i--;
            _text = string_delete(_text, i+1, 1);
            _text_width = string_width(_text + _ellipsis);
        }
        return _text + _ellipsis;
    } else {
        return _text;
    }
}

function integer_to_letters(_integer) {
    var _ones = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
    var _teens = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];
    var _tens = ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];
    var _thousands = ["", "thousand", "million", "billion"];

    if (_integer == 0) return "zero";  // Handle zero

    var _num_str = "";
    var _num_int = floor(_integer);

    if (_num_int < 10) {
        _num_str += _ones[_num_int];
    } else if (_num_int < 20) {
        _num_str += _teens[_num_int - 10];
    } else if (_num_int < 100) {
        _num_str += _tens[floor(_num_int / 10)] + (_num_int % 10 != 0 ? " " + _ones[_num_int % 10] : "");
    } else if (_num_int < 1000) {
        _num_str += _ones[floor(_num_int / 100)] + " hundred" + (_num_int % 100 != 0 ? " " + integer_to_letters(_num_int % 100) : "");
    } else {
        for (var _i = 0; _num_int > 0; _i += 1) {
            if (_num_int % 1000 != 0) {
                var _part = integer_to_letters(_num_int % 1000);
                _num_str = _part + " " + _thousands[_i] + (_num_str != "" ? " " : "") + _num_str;
            }
            _num_int = floor(_num_int / 1000);
        }
    }

    return string_trim(_num_str);
}
