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
        handle_exception(_exception);
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

function integer_to_letters(_integer, _capitalize = false) {
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

    _num_str = string_trim(_num_str);

    if (_capitalize) {
        string_upper_first(_num_str);
    }

    return _num_str;
}

function string_reverse(argument0) {
    /*
    Reverse String
    Reverse a string with ease

    Argument0 - String
    */

	var str,length,i,out,char;
	str=argument0
	out=""
	length=string_length(argument0)
	for(i=0;i<string_length(argument0);i+=1){
        char=string_char_at(str,length-i)
        out+=char
	}
	return out;
}

function string_rpos(argument0, argument1) {
	/*
	**  Usage:
	**      string_rpos(substr,str)
	**
	**  Arguments:
	**      substr      a substring of text
	**      str         a string of text
	**
	**  Returns:
	**      the right-most position of the given
	**      substring within the given string
	*/

    var sub,str,pos,ind;
    sub = argument0;
    str = argument1;
    pos = 0;
    ind = 0;
    do {
        pos += ind;
        ind = string_pos(sub,str);
        str = string_delete(str,1,ind);
    } until (ind == 0);
    return pos;
}

function scr_convert_company_to_string(company_num, possessive = false, flavour=false){
	var _company_num = company_num;
	var _suffixes = ["st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "th"];
	var _flavours = ["Veteran", "Battle", "Battle", "Battle", "Battle", "Reserve", "Reserve", "Reserve", "Reserve", "Scout"];
	var _str_company = possessive ? "Company's" : "Company";

	if (_company_num < 1) || (_company_num > 10) {
		return "";	
	} else {
		var _flavour_text = flavour ? _flavours[_company_num - 1] : "";
		_company_num = string(_company_num) + _suffixes[_company_num - 1];
		var _converted_string = string_join(" ", _company_num, _flavour_text, _str_company);
		return _converted_string;
	}
}

function string_to_integer(argument0) {

	// Argument0: string

	// This script converts a word or longer string into an integer, with each letter
	// corresponding to a value from 1-26.  The purpose of this is to allow a marine's
	// name to generate a semi-unique variable for the future display of veterency
	// decorations when inspected in management.  Whether it is odd, from 0-9, and so
	// on can determine what shows on their picture at certain experience values.

	var lol,m1,val;
	lol=argument0;val=0;
	m1=string_length(lol);

    repeat(m1){
        if (string_lower(string_char_at(lol,0))="a") then val+=1;
        if (string_lower(string_char_at(lol,0))="b") then val+=2;
        if (string_lower(string_char_at(lol,0))="c") then val+=3;
        if (string_lower(string_char_at(lol,0))="d") then val+=4;
        if (string_lower(string_char_at(lol,0))="e") then val+=5;
        if (string_lower(string_char_at(lol,0))="f") then val+=6;
        if (string_lower(string_char_at(lol,0))="g") then val+=7;
        if (string_lower(string_char_at(lol,0))="h") then val+=8;
        if (string_lower(string_char_at(lol,0))="i") then val+=9;
        if (string_lower(string_char_at(lol,0))="j") then val+=10;
        if (string_lower(string_char_at(lol,0))="k") then val+=11;
        if (string_lower(string_char_at(lol,0))="l") then val+=12;
        if (string_lower(string_char_at(lol,0))="m") then val+=13;
        if (string_lower(string_char_at(lol,0))="n") then val+=14;
        if (string_lower(string_char_at(lol,0))="o") then val+=15;
        if (string_lower(string_char_at(lol,0))="p") then val+=16;
        if (string_lower(string_char_at(lol,0))="q") then val+=17;
        if (string_lower(string_char_at(lol,0))="r") then val+=18;
        if (string_lower(string_char_at(lol,0))="s") then val+=19;
        if (string_lower(string_char_at(lol,0))="t") then val+=20;
        if (string_lower(string_char_at(lol,0))="u") then val+=21;
        if (string_lower(string_char_at(lol,0))="v") then val+=22;
        if (string_lower(string_char_at(lol,0))="w") then val+=23;
        if (string_lower(string_char_at(lol,0))="x") then val+=24;
        if (string_lower(string_char_at(lol,0))="y") then val+=25;
        if (string_lower(string_char_at(lol,0))="z") then val+=26;
        lol=string_delete(lol,0,1);
    }
    return(val);


}