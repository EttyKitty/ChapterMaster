function log_into_file(_message) {
    var _entry = string(_message);
    var _date_time = string(current_day) + "-" + string (current_month) + "-" + string(current_year) + "_" + string(current_hour) + string(current_minute) + string(current_second);
    var _log_file = file_text_open_write("ErrorLogs/" + $"error_log_{_date_time}.log");

    file_text_write_string(_log_file, _entry);
    file_text_close(_log_file);
}

function try_and_report_loop(dev_marker="generic crash",func, turn_end=true, args=[], catch_custom=0, catch_args=[]){
    #macro ERROR_MESSAGE $"The error log is automatically copied into your clipboard and a copy is created at: \nC:>Users>(UserName)>AppData>Local>ChapterMaster>ErrorLogs \n\nPlease, do the following: \n\n1) Create a bug report on the bug-report-forum in our 'Chapter Master Discord' server. \n\n2) Press CTRL+V to paste the error log into the bug report. \n\n3) If for some reason the error log wasn't pasted, find the location that is mentioned above and attach the latest (sort by time) error_log to your bug report. \n\n\nThank you :)"

    try{
        method_call(func,args);
    } catch (_exception){
        var _popup_header = $"Your game just encountered an error ({dev_marker}) :(";
        var _popup_message = ERROR_MESSAGE + "\n\n\nP.S. You can try to continue playing - if the error is not severe, the game should continue working, just try to avoid what caused it. \n\nBut it's recommended to wait for a response on the bug-report forum, otherwise you may make the issue worse.";

        pip = instance_create(0,0,obj_popup);
        pip.title = _popup_header;
        pip.text = _popup_message;
        pip.image = "debug"

        var _formatted_stacktrace = "";
        // Loop through the array
        for (var i = 0; i < array_length(_exception.stacktrace); i++) {
            _formatted_stacktrace += _exception.stacktrace[i];
            // Add newline character
            if (i < array_length(_exception.stacktrace) - 1) {
                _formatted_stacktrace += "\n";
            }
        }

        var _line_break = LINE_BREAK_92;
        var _full_message = $"{_line_break}\nGame Version: {global.game_version}\n\n{_exception.longMessage}\n\nIn:\n{_exception.script}\n\nStacktrace:\n{_formatted_stacktrace}\n{_line_break}";

        log_into_file(_full_message);
        clipboard_set_text(string(_full_message));
    
        show_debug_message(_full_message);

        if (is_method(catch_custom)) {
            method_call(catch_custom, catch_args);
        }
    }
}

exception_unhandled_handler(function(_exception) {
    var _formatted_stacktrace = "";
    // Loop through the array
    for (var i = 0; i < array_length(_exception.stacktrace); i++) {
        _formatted_stacktrace += _exception.stacktrace[i];
        // Add newline character
        if (i < array_length(_exception.stacktrace) - 1) {
            _formatted_stacktrace += "\n";
        }
    }

    var _line_break = LINE_BREAK_92;
    var _full_message = $"{_line_break}\nGame Version: {GM_version}\n\n{_exception.longMessage}\n\nIn:\n{_exception.script}\n\nStacktrace:\n{_formatted_stacktrace}\n{_line_break}";

    log_into_file(_full_message);
    clipboard_set_text(_full_message);

    show_debug_message(_line_break);
    show_debug_message( "Unhandled exception!");
    show_debug_message(_full_message);

    var _player_message = ERROR_MESSAGE;
    show_message(_player_message);

    return 0;
});