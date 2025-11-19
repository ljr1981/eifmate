note
	description: "[
		Builds structured JSON responses for the CLI using the SIMPLE_JSON library.
		Formats compiler results, errors, and metadata for AI consumption.
	]"
	author: "EifMate"
	date: "$Date$"
	revision: "$Revision$"
	model: "max_contracts"

class
	EM_RESPONSE

create
	make_success,
	make_failure

feature {NONE} -- Initialization

	make_success (a_output: STRING)
			-- Initialize a successful response.
		require
			output_attached: a_output /= Void
		do
			is_success := True
			output := a_output

			create {ARRAYED_LIST [EM_ERROR]} errors.make (0)
			errors.compare_objects -- Value comparison for testing equality

			create {ARRAYED_LIST [EM_ERROR]} warnings.make (0)
			warnings.compare_objects

			timestamp := generated_timestamp
		ensure
			success_set: is_success
			output_set: output = a_output
			no_errors: errors.is_empty
			warnings_initialized: warnings.is_empty
			timestamp_set: not timestamp.is_empty
		end

	make_failure (a_output: STRING; a_errors: LIST [EM_ERROR])
			-- Initialize a failure response with errors.
		require
			output_attached: a_output /= Void
			errors_attached: a_errors /= Void
			no_void_errors: across a_errors as err all err /= Void end
		do
			is_success := False
			output := a_output
			errors := a_errors

			create {ARRAYED_LIST [EM_ERROR]} warnings.make (0)
			warnings.compare_objects

			timestamp := generated_timestamp
		ensure
			failure_set: not is_success
			output_set: output = a_output
			errors_set: errors = a_errors
			warnings_initialized: warnings.is_empty
			timestamp_set: not timestamp.is_empty
		end

feature -- Access

	is_success: BOOLEAN
			-- Did the operation succeed?

	output: STRING
			-- Raw output from the tool (e.g. ec.exe stdout).

	errors: LIST [EM_ERROR]
			-- List of parsing errors (if any).

	warnings: LIST [EM_ERROR]
			-- List of warnings (if any).

	timestamp: STRING
			-- ISO 8601 timestamp of generation.

feature -- Conversion

	to_json: STRING
			-- Convert response to JSON string using SIMPLE_JSON.
		local
			l_json: SIMPLE_JSON_OBJECT
			l_errors_array: SIMPLE_JSON_ARRAY
			l_warnings_array: SIMPLE_JSON_ARRAY
			l_dummy_obj: SIMPLE_JSON_OBJECT
			l_dummy_arr: SIMPLE_JSON_ARRAY
		do
			create l_json.make

			-- 1. Status
			l_dummy_obj := l_json.put_boolean (is_success, {STRING_32} "success")

			-- 2. Output
			l_dummy_obj := l_json.put_string (output.to_string_32, {STRING_32} "output")

			-- 3. Errors Array
			create l_errors_array.make
			across errors as ic loop
				l_dummy_arr := l_errors_array.add_object (error_to_json (ic))
			end
			l_dummy_obj := l_json.put_array (l_errors_array, {STRING_32} "errors")

			-- 4. Warnings Array
			create l_warnings_array.make
			across warnings as ic loop
				l_dummy_arr := l_warnings_array.add_object (error_to_json (ic))
			end
			l_dummy_obj := l_json.put_array (l_warnings_array, {STRING_32} "warnings")

			-- 5. Timestamp
			l_dummy_obj := l_json.put_string (timestamp.to_string_32, {STRING_32} "timestamp")

			-- Serialize
			Result := l_json.to_json_string.as_string_8

			-- Debug checks for JSON integrity
			check
				json_starts_correctly: Result.starts_with ("{")
				json_ends_correctly: Result.ends_with ("}")
			end
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
			valid_json_start: Result.starts_with ("{")
			valid_json_end: Result.ends_with ("}")
			contains_success_key: Result.has_substring ("success")
			contains_output_key: Result.has_substring ("output")
			contains_errors_key: Result.has_substring ("errors")
		end

feature {NONE} -- Implementation

	error_to_json (a_error: EM_ERROR): SIMPLE_JSON_OBJECT
			-- Convert a single EM_ERROR to a SIMPLE_JSON_OBJECT.
		require
			error_attached: a_error /= Void
		local
			l_obj: SIMPLE_JSON_OBJECT
			l_dummy: SIMPLE_JSON_OBJECT
		do
			create l_obj.make

			-- Core Fields
			l_dummy := l_obj.put_string (a_error.code.to_string_32, {STRING_32} "code")
			l_dummy := l_obj.put_string (a_error.message.to_string_32, {STRING_32} "message")

			-- Severity/Category
			if a_error.has_category then
				l_dummy := l_obj.put_string (a_error.category.to_string_32, {STRING_32} "severity")
			else
				l_dummy := l_obj.put_string ({STRING_32} "error", {STRING_32} "severity")
			end

			-- Suggestion/Help
			if a_error.has_help_text then
				l_dummy := l_obj.put_string (a_error.help_text.to_string_32, {STRING_32} "suggestion")
			end

			-- Flattened Location Data
			if attached a_error.location as l_loc then
				l_dummy := l_obj.put_string (l_loc.class_name.to_string_32, {STRING_32} "class")

				if l_loc.has_feature_name then
					l_dummy := l_obj.put_string (l_loc.feature_name.to_string_32, {STRING_32} "feature")
				end

				l_dummy := l_obj.put_integer (l_loc.line_number.to_integer_64, {STRING_32} "line")

				if l_loc.has_file_path then
					l_dummy := l_obj.put_string (l_loc.file_path.to_string_32, {STRING_32} "file")
				end
			end

			Result := l_obj
		ensure
			result_attached: Result /= Void
		end

	generated_timestamp: STRING
			-- Generate current timestamp (ISO 8601 approximation).
		local
			l_time: DATE_TIME
			l_date_str: STRING
			l_time_str: STRING
		do
			create l_time.make_now

			-- Format date and time separately to avoid parser confusion with 'T' and 'Z' literals
			l_date_str := l_time.formatted_out ("yyyy-[0]mm-[0]dd")
			l_time_str := l_time.formatted_out ("[0]hh:[0]mi:[0]ss")

			Result := l_date_str + "T" + l_time_str + "Z"

			-- Optional: Debug print to see exactly what is generating if it fails again
			debug ("verify_timestamp")
				print ("%N[DEBUG] Timestamp generated: " + Result + " (Length: " + Result.count.out + ")%N")
			end
		ensure
			result_attached: Result /= Void
			-- 2024-01-01T00:00:00Z is exactly 20 chars
			valid_length: Result.count >= 20
			has_time_separator: Result.has ('T')
			has_utc_marker: Result.ends_with ("Z")
		end

invariant
	output_not_void: output /= Void
	errors_not_void: errors /= Void
	warnings_not_void: warnings /= Void
	timestamp_not_void: timestamp /= Void
	timestamp_not_empty: not timestamp.is_empty

	-- Logical consistency invariants
	success_implies_no_errors: is_success implies errors.is_empty
	-- Note: The reverse (not is_success implies not errors.is_empty) is usually true,
	-- but strictly speaking a tool could fail without parsing specific error objects.

	-- Deep list integrity (useful if not fully void-safe)
	errors_contain_no_voids: across errors as e all e /= Void end
	warnings_contain_no_voids: across warnings as w all w /= Void end

end
