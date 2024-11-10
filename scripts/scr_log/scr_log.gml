#macro STR_error_message_head $"Your game just encountered and caught an error :("
#macro STR_error_message_head2 $"Your game just encountered a critical error :("
#macro STR_error_message_head3 $"Your game just encountered and caught an error ({0}) :("
#macro MSG_error_message $"The error log is automatically copied into your clipboard and a copy is created at: \nC:>Users>(UserName)>AppData>Local>ChapterMaster>ErrorLogs\n\nPlease, follow these steps:\n1) Report on our 'Chapter Master Discord' server.\n2) Press CTRL+V to paste the error log.\n3) Title the report with the error log's first line.\n4) If the log isn't pasted, locate and attach the latest error log file.\n\nThank you!"
#macro MSG_error_message_ps $"P.S. You can ALT-TAB and try to continue playing, though it’s recommended to wait for a response in the bug-report forum."

/// @description Logs the _message into a file in the ErrorLogs folder.
/// @param {string} _message - The message to log.
function log_into_file(_message) {
    if (string_length(_message) > 0) {
        var _date_time = $"{current_day}-{current_month}-{current_year}_{current_hour}{current_minute}{current_second}";
        var _log_file = file_text_open_write($"ErrorLogs/error_{_date_time}.log");
        file_text_write_string(_log_file, _message);
        file_text_close(_log_file);
    }
}

/// @description Displays a popup, logs the error, and copies to clipboard.
/// @param {string} _header - Header for the error popup.
/// @param {string} _message - Detailed message for the error.
/// @param {string} _stacktrace - Optional
function show_error_popup(_header, _message, _stacktrace="") {
    var _full_message = $"{LB_92}\n{_header}\nGame Version: {global.game_version}; Build Date: {global.build_date}\n\n{_message}\nDetails:\n{_stacktrace}\n{LB_92}";
    var _player_message = $"{STR_error_message_head}\n\n{_header}\n\n{MSG_error_message}\n\n{MSG_error_message_ps}";
    show_message(_player_message);
    log_into_file(_full_message);
    clipboard_set_text($"{_header}\n{markdown_codeblock(_full_message)}");
    show_debug_message(_full_message);
}

/// @function handle_exception
/// @description Manages exception display and logging with optional severity.
/// @param {exception} _exception - The exception to handle.
/// @param {string} custom_title - Optional custom title for the error popup.
/// @param {bool} non_critical - Whether the error is non-critical (default: true).
/// @param {string} error_marker - Optional marker for the error.
function handle_exception(_exception, custom_title=STR_error_message_head, non_critical=true, error_marker="") {
    var _header = non_critical ? custom_title : STR_error_message_head2;
    var _message = _exception.longMessage;
    var _stacktrace = array_to_string_list(_exception.stacktrace);
    show_error_popup(_header, _message, _stacktrace);
}

/// @description Attempts to run a function and reports any errors caught.
/// @param {string} dev_marker - Developer marker for the error.
/// @param {function} func - The function to run.
/// @param {bool} turn_end - Whether to end the turn after an error.
/// @param {array} args - Arguments to pass to the function.
/// @param {function} catch_custom - Custom function to run on error.
/// @param {array} catch_args - Arguments to pass to the custom function.
function try_and_report_loop(dev_marker="generic crash", func, turn_end=true, args=[], catch_custom=0, catch_args=[]) {
    try {
        method_call(func, args);
    } catch (_exception) {
        handle_exception(_exception, string(STR_error_message_head3, dev_marker), true, dev_marker);
        if (is_method(catch_custom)) {
            method_call(catch_custom, catch_args);
        }
    }
}

/// @description Shows a popup for errors triggered by an unexpected condition(s).
/// @param {string} _message - The message to display to the user.
/// @param {string} _header - Optional header for the popup (default: "Assertion Error").
function assert_error_popup(_message, _header="Assertion Error") {
    var _stacktrace_array = debug_get_callstack();

    array_shift(_stacktrace_array); // throw away the first line, it's this function
    array_pop(_stacktrace_array); // and the last line, it's the `0` debug_get_callstack returns for the top of the stack

    var _stacktrace = array_to_string_list(_stacktrace_array);

    show_error_popup(_header, _message, _stacktrace);
}

exception_unhandled_handler(function(_exception) {
    handle_exception(_exception, STR_error_message_head2, false);
    return 0;
});

/// @function markdown_codeblock
/// @description Formats text as a code block.
/// @param {string} _message - The message to format.
/// @returns {string} The formatted message.
function markdown_codeblock(_message) {
    return string_length(_message) > 0 ? $"```\n{_message}\n```" : "";
}