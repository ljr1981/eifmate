note
	description: "[
		Represents a single compilation error or warning.
		Captures all available information about the error including:
		- Error code (e.g., VUTA(2), VEEN)
		- Message text
		- Severity level
		- Location information (class, feature, line, file)
		- Suggestions for fixing
		
		Can be serialized to JSON for transmission to Claude.
		
		Usage:
			create error.make ("VUTA(2)", "Feature not found", severity_error)
			error.set_class_name ("MY_CLASS")
			error.set_line_number (42)
			json := error.to_json
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_ERROR

inherit
	EM_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_code: STRING_8; a_message: STRING_8; a_severity: INTEGER)
			-- Initialize error with code, message, and severity
		require
			code_attached: a_code /= Void
			code_not_empty: not a_code.is_empty
			message_attached: a_message /= Void
			valid_severity: a_severity = Error_severity_error or
			                a_severity = Error_severity_warning or
			                a_severity = Error_severity_info
		do
			code := a_code
			message := a_message
			severity := a_severity
			
			create class_name.make_empty
			create feature_name.make_empty
			create file_path.make_empty
			create suggestion.make_empty
			line_number := 0
		ensure
			code_set: code = a_code
			message_set: message = a_message
			severity_set: severity = a_severity
		end

feature -- Access

	code: STRING_8
			-- Error code (e.g., "VUTA(2)", "VEEN")

	message: STRING_8
			-- Error message text

	severity: INTEGER
			-- Severity level (error, warning, info)

	class_name: STRING_8
			-- Class where error occurred

	feature_name: STRING_8
			-- Feature where error occurred

	file_path: STRING_8
			-- Full path to source file

	line_number: INTEGER
			-- Line number in source file

	suggestion: STRING_8
			-- Suggestion for fixing the error

feature -- Status report

	is_error: BOOLEAN
			-- Is this an error (as opposed to warning)?
		do
			Result := severity = Error_severity_error
		end

	is_warning: BOOLEAN
			-- Is this a warning (as opposed to error)?
		do
			Result := severity = Error_severity_warning
		end

	is_info: BOOLEAN
			-- Is this informational?
		do
			Result := severity = Error_severity_info
		end

	has_location: BOOLEAN
			-- Do we have location information?
		do
			Result := not class_name.is_empty or line_number > 0
		end

	has_suggestion: BOOLEAN
			-- Do we have a suggestion for fixing?
		do
			Result := not suggestion.is_empty
		end

feature -- Element change

	set_class_name (a_name: STRING_8)
			-- Set class name where error occurred
		require
			name_attached: a_name /= Void
		do
			class_name := a_name.twin
		ensure
			class_name_set: class_name.same_string (a_name)
		end

	set_feature_name (a_name: STRING_8)
			-- Set feature name where error occurred
		require
			name_attached: a_name /= Void
		do
			feature_name := a_name.twin
		ensure
			feature_name_set: feature_name.same_string (a_name)
		end

	set_file_path (a_path: STRING_8)
			-- Set source file path
		require
			path_attached: a_path /= Void
		do
			file_path := a_path.twin
		ensure
			file_path_set: file_path.same_string (a_path)
		end

	set_line_number (a_line: INTEGER)
			-- Set line number
		require
			valid_line: a_line >= 0
		do
			line_number := a_line
		ensure
			line_number_set: line_number = a_line
		end

	set_suggestion (a_suggestion: STRING_8)
			-- Set suggestion for fixing
		require
			suggestion_attached: a_suggestion /= Void
		do
			suggestion := a_suggestion.twin
		ensure
			suggestion_set: suggestion.same_string (a_suggestion)
		end

	append_to_message (a_text: STRING_8)
			-- Append text to message
		require
			text_attached: a_text /= Void
		do
			message.append (a_text)
		end

feature -- Conversion

	severity_string: STRING_8
			-- String representation of severity
		do
			inspect severity
			when Error_severity_error then
				Result := "error"
			when Error_severity_warning then
				Result := "warning"
			when Error_severity_info then
				Result := "info"
			else
				Result := "unknown"
			end
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

	to_string: STRING_8
			-- Human-readable string representation
		do
			create Result.make (256)
			
			Result.append ("[")
			Result.append (severity_string.as_upper)
			Result.append ("] ")
			Result.append (code)
			
			if not class_name.is_empty then
				Result.append (" in class ")
				Result.append (class_name)
			end
			
			if not feature_name.is_empty then
				Result.append (".")
				Result.append (feature_name)
			end
			
			if line_number > 0 then
				Result.append (" (line ")
				Result.append (line_number.out)
				Result.append (")")
			end
			
			Result.append ("%N")
			Result.append (message)
			
			if not suggestion.is_empty then
				Result.append ("%NSuggestion: ")
				Result.append (suggestion)
			end
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

invariant
	code_attached: code /= Void
	code_not_empty: not code.is_empty
	message_attached: message /= Void
	valid_severity: severity = Error_severity_error or
	                severity = Error_severity_warning or
	                severity = Error_severity_info
	class_name_attached: class_name /= Void
	feature_name_attached: feature_name /= Void
	file_path_attached: file_path /= Void
	suggestion_attached: suggestion /= Void
	line_number_non_negative: line_number >= 0

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
