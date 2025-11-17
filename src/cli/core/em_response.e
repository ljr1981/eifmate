note
	description: "[
		JSON response builder for EifMate.
		Constructs structured JSON responses to send back to Claude.
		
		Response format:
		{
			\"success\": true,
			\"output\": \"...\",
			\"errors\": [
				{
					\"code\": \"VUTA(2)\",
					\"message\": \"...\",
					\"severity\": \"error\",
					\"class\": \"MY_CLASS\",
					\"feature\": \"make\",
					\"line\": 42,
					\"file\": \"D:/src/my_class.e\",
					\"suggestion\": \"...\"
				}
			],
			\"warnings\": [...],
			\"timestamp\": \"2024-11-16T12:34:56Z\"
		}
		
		Usage:
			create response.make
			response.set_success (True)
			response.set_output (compiler_output)
			across errors as ic loop
				response.add_error (ic)
			end
			json := response.to_json_string
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_RESPONSE

inherit
	EM_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize response
		local
			l_dt: DATE_TIME
		do
			create output.make_empty
			create errors.make (0)
			create warnings.make (0)
			success := False

			-- Set current timestamp
			create l_dt.make_now_utc
			timestamp := l_dt
		ensure
			output_ready: output /= Void
			errors_ready: errors /= Void
			warnings_ready: warnings /= Void
			timestamp_set: timestamp /= Void
		end

feature -- Access

	success: BOOLEAN
			-- Did the operation succeed?

	output: STRING_8
			-- Raw compiler output

	errors: ARRAYED_LIST [EM_ERROR]
			-- Collection of errors

	warnings: ARRAYED_LIST [EM_ERROR]
			-- Collection of warnings

	timestamp: DATE_TIME
			-- When response was created

feature -- Element change

	set_success (a_success: BOOLEAN)
			-- Set success flag
		do
			success := a_success
		ensure
			success_set: success = a_success
		end

	set_output (a_output: STRING_8)
			-- Set raw compiler output
		require
			output_attached: a_output /= Void
		do
			output := a_output.twin
		ensure
			output_set: output.same_string (a_output)
		end

	add_error (a_error: EM_ERROR)
			-- Add error to collection
		require
			error_attached: a_error /= Void
		do
			if a_error.is_error then
				errors.extend (a_error)
			elseif a_error.is_warning then
				warnings.extend (a_error)
			end
		end

	add_errors (a_errors: ARRAYED_LIST [EM_ERROR])
			-- Add multiple errors
		require
			errors_attached: a_errors /= Void
		do
			across a_errors as ic loop
				add_error (ic)
			end
		end

feature -- Conversion

	to_json_string: STRING_8
			-- Convert to JSON string
		local
			l_json_obj: SIMPLE_JSON_OBJECT
			l_errors_arr: SIMPLE_JSON_ARRAY
			l_warnings_arr: SIMPLE_JSON_ARRAY
			l_pretty_printer: SIMPLE_JSON_PRETTY_PRINTER
		do
			-- Build main object
			create l_json_obj.make

			-- Add success flag
			l_json_obj.put_boolean (success, Json_key_success).do_nothing

			-- Add output
			l_json_obj.put_string (output, Json_key_output).do_nothing

			-- Build errors array
			create l_errors_arr.make
			across errors as ic loop
				l_errors_arr.add_object (error_to_json_object (ic)).do_nothing
			end
			l_json_obj.put_array (l_errors_arr, Json_key_errors).do_nothing

			-- Build warnings array
			create l_warnings_arr.make
			across warnings as ic loop
				l_warnings_arr.add_object (error_to_json_object (ic)).do_nothing
			end
			l_json_obj.put_array (l_warnings_arr, Json_key_warnings).do_nothing

			-- Add timestamp
			l_json_obj.put_string (timestamp_iso8601, Json_key_timestamp).do_nothing

			-- Pretty print
			create l_pretty_printer.make
			Result := l_pretty_printer.print_json_value (l_json_obj.json_value).to_string_8
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

feature -- Status report

	has_errors: BOOLEAN
			-- Were there any errors?
		do
			Result := not errors.is_empty
		end

	has_warnings: BOOLEAN
			-- Were there any warnings?
		do
			Result := not warnings.is_empty
		end

	error_count: INTEGER
			-- Number of errors
		do
			Result := errors.count
		ensure
			non_negative: Result >= 0
		end

	warning_count: INTEGER
			-- Number of warnings
		do
			Result := warnings.count
		ensure
			non_negative: Result >= 0
		end

feature {NONE} -- Implementation

	error_to_json_object (a_error: EM_ERROR): SIMPLE_JSON_OBJECT
			-- Convert error to JSON object
		require
			error_attached: a_error /= Void
		do
			create Result.make

			Result.put_string (a_error.code, Json_key_error_code).do_nothing
			Result.put_string (a_error.message, Json_key_message).do_nothing
			Result.put_string (a_error.severity_string, Json_key_severity).do_nothing

			if not a_error.class_name.is_empty then
				Result.put_string (a_error.class_name, Json_key_class_name).do_nothing
			end

			if not a_error.feature_name.is_empty then
				Result.put_string (a_error.feature_name, Json_key_feature_name).do_nothing
			end

			if a_error.line_number > 0 then
				Result.put_integer (a_error.line_number, Json_key_line_number).do_nothing
			end

			if not a_error.file_path.is_empty then
				Result.put_string (a_error.file_path, Json_key_file_path).do_nothing
			end

			if not a_error.suggestion.is_empty then
				Result.put_string (a_error.suggestion, Json_key_suggestion).do_nothing
			end
		ensure
			result_attached: Result /= Void
		end

	timestamp_iso8601: STRING_8
			-- ISO 8601 formatted timestamp
		local
			l_year, l_month, l_day: INTEGER
			l_hour, l_minute, l_second: INTEGER
		do
			l_year := timestamp.year
			l_month := timestamp.month
			l_day := timestamp.day
			l_hour := timestamp.hour
			l_minute := timestamp.minute
			l_second := timestamp.second

			create Result.make (25)

			-- YYYY-MM-DDTHH:MM:SSZ
			Result.append (l_year.out)
			Result.append ("-")
			Result.append (zero_pad (l_month, 2))
			Result.append ("-")
			Result.append (zero_pad (l_day, 2))
			Result.append ("T")
			Result.append (zero_pad (l_hour, 2))
			Result.append (":")
			Result.append (zero_pad (l_minute, 2))
			Result.append (":")
			Result.append (zero_pad (l_second, 2))
			Result.append ("Z")
		ensure
			result_attached: Result /= Void
			proper_length: Result.count >= 20
		end

	zero_pad (a_value: INTEGER; a_width: INTEGER): STRING_8
			-- Zero-pad integer to specified width
		require
			non_negative: a_value >= 0
			positive_width: a_width > 0
		local
			l_string: STRING_8
		do
			l_string := a_value.out

			create Result.make (a_width)
			from
			until
				Result.count >= a_width - l_string.count
			loop
				Result.append ("0")
			end
			Result.append (l_string)
		ensure
			result_attached: Result /= Void
			minimum_width: Result.count >= a_width
		end

invariant
	output_attached: output /= Void
	errors_attached: errors /= Void
	warnings_attached: warnings /= Void
	timestamp_attached: timestamp /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
