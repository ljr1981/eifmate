note
	description: "[
		Parser for Eiffel compiler error output.
		Extracts structured error information from ec.exe output.
		
		Handles error patterns like:
		- Error code: VUTA(2)
		- What to do: check whether feature name `do_nothing' is spelled correctly ...
		- Class: MY_CLASS
		- Feature: make
		- Line: 42
		
		Also handles:
		- Warning messages
		- Degree progress messages
		- Success/failure indicators
		
		Usage:
			create parser.make
			parser.parse (compiler_output)
			across parser.errors as ic loop
				print (ic.code + ": " + ic.message)
			end
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_ERROR_PARSER

inherit
	EM_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize parser
		do
			create errors.make (0)
			create warnings.make (0)
		ensure
			errors_ready: errors /= Void
			warnings_ready: warnings /= Void
		end

feature -- Access

	errors: ARRAYED_LIST [EM_ERROR]
			-- Parsed errors from last parse

	warnings: ARRAYED_LIST [EM_ERROR]
			-- Parsed warnings from last parse

feature -- Status report

	has_errors: BOOLEAN
			-- Were errors found in last parse?
		do
			Result := not errors.is_empty
		end

	has_warnings: BOOLEAN
			-- Were warnings found in last parse?
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

feature -- Parsing

	parse (a_output: STRING_8)
			-- Parse compiler output and extract errors
		require
			output_attached: a_output /= Void
		local
			l_lines: LIST [STRING_8]
			l_line: STRING_8
			l_error: detachable EM_ERROR
			l_in_error: BOOLEAN
		do
			-- Reset
			errors.wipe_out
			warnings.wipe_out

			-- Split into lines
			l_lines := a_output.split ('%N')

			-- Parse each line
			across l_lines as ic loop
				l_line := ic

				-- Check for error start
				if is_error_start (l_line) then
					-- Save previous error if any
					if attached l_error as al_error then
						add_error_to_list (al_error)
					end
					
					-- Start new error
					l_error := create_error_from_line (l_line)
					l_in_error := True
					
				elseif is_warning_start (l_line) then
					-- Save previous error if any
					if attached l_error as al_error then
						add_error_to_list (al_error)
					end
					
					-- Start new warning
					l_error := create_warning_from_line (l_line)
					l_in_error := True
					
				elseif l_in_error and attached l_error as al_error then
					-- Add details to current error
					add_error_detail (al_error, l_line)
				end
			end

			-- Don't forget last error
			if attached l_error as al_error then
				add_error_to_list (al_error)
			end
		ensure
			errors_attached: errors /= Void
			warnings_attached: warnings /= Void
		end

feature {NONE} -- Error Detection

	is_error_start (a_line: STRING_8): BOOLEAN
			-- Does line indicate start of error?
		require
			line_attached: a_line /= Void
		do
			-- Error lines typically start with "Error code:"
			Result := a_line.has_substring ("Error code:")
		end

	is_warning_start (a_line: STRING_8): BOOLEAN
			-- Does line indicate start of warning?
		require
			line_attached: a_line /= Void
		do
			-- Warning lines typically contain "Warning:"
			Result := a_line.has_substring ("Warning:")
		end

feature {NONE} -- Error Creation

	create_error_from_line (a_line: STRING_8): EM_ERROR
			-- Create error object from error start line
		require
			line_attached: a_line /= Void
			is_error: is_error_start (a_line)
		local
			l_code: STRING_8
			l_message: STRING_8
		do
			-- Extract error code (e.g., "VUTA(2)")
			l_code := extract_error_code (a_line)
			
			-- Initial message is the line itself
			create l_message.make_from_string (a_line)
			
			create Result.make (l_code, l_message, Error_severity_error)
		ensure
			result_attached: Result /= Void
		end

	create_warning_from_line (a_line: STRING_8): EM_ERROR
			-- Create warning object from warning start line
		require
			line_attached: a_line /= Void
			is_warning: is_warning_start (a_line)
		local
			l_code: STRING_8
			l_message: STRING_8
		do
			-- Warnings typically don't have codes like errors
			l_code := "WARNING"
			
			create l_message.make_from_string (a_line)
			
			create Result.make (l_code, l_message, Error_severity_warning)
		ensure
			result_attached: Result /= Void
		end

	add_error_detail (a_error: EM_ERROR; a_line: STRING_8)
			-- Add detail line to error object
		require
			error_attached: a_error /= Void
			line_attached: a_line /= Void
		local
			l_trimmed: STRING_8
		do
			l_trimmed := a_line.twin
			l_trimmed.left_adjust
			l_trimmed.right_adjust

			if not l_trimmed.is_empty then
				-- Check for specific detail types
				if l_trimmed.has_substring ("What to do:") then
					a_error.set_suggestion (extract_what_to_do (l_trimmed))
					
				elseif l_trimmed.has_substring ("Class:") then
					a_error.set_class_name (extract_class_name (l_trimmed))
					
				elseif l_trimmed.has_substring ("Feature:") then
					a_error.set_feature_name (extract_feature_name (l_trimmed))
					
				elseif l_trimmed.has_substring ("Line:") then
					a_error.set_line_number (extract_line_number (l_trimmed))
					
				elseif l_trimmed.has_substring ("File:") then
					a_error.set_file_path (extract_file_path (l_trimmed))
					
				else
					-- Append to message
					a_error.append_to_message ("%N" + l_trimmed)
				end
			end
		end

feature {NONE} -- Extraction

	extract_error_code (a_line: STRING_8): STRING_8
			-- Extract error code from line (e.g., "VUTA(2)")
		require
			line_attached: a_line /= Void
		local
			l_start, l_end: INTEGER
		do
			-- Look for pattern like "Error code: VUTA(2)"
			create Result.make_empty
			
			l_start := a_line.substring_index ("Error code:", 1)
			if l_start > 0 then
				l_start := l_start + 11  -- Length of "Error code:"
				
				-- Find next whitespace or end of line
				l_end := a_line.index_of (' ', l_start)
				if l_end = 0 then
					l_end := a_line.count
				end
				
				if l_end > l_start then
					Result := a_line.substring (l_start, l_end).twin
					Result.left_adjust
					Result.right_adjust
				end
			end
			
			if Result.is_empty then
				Result := "UNKNOWN"
			end
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

	extract_what_to_do (a_line: STRING_8): STRING_8
			-- Extract suggestion from "What to do:" line
		require
			line_attached: a_line /= Void
		local
			l_start: INTEGER
		do
			l_start := a_line.substring_index ("What to do:", 1)
			if l_start > 0 then
				l_start := l_start + 11  -- Length of "What to do:"
				if l_start <= a_line.count then
					Result := a_line.substring (l_start + 1, a_line.count).twin
					Result.left_adjust
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	extract_class_name (a_line: STRING_8): STRING_8
			-- Extract class name from "Class:" line
		require
			line_attached: a_line /= Void
		local
			l_start: INTEGER
		do
			l_start := a_line.substring_index ("Class:", 1)
			if l_start > 0 then
				l_start := l_start + 6  -- Length of "Class:"
				if l_start <= a_line.count then
					Result := a_line.substring (l_start + 1, a_line.count).twin
					Result.left_adjust
					Result.right_adjust
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	extract_feature_name (a_line: STRING_8): STRING_8
			-- Extract feature name from "Feature:" line
		require
			line_attached: a_line /= Void
		local
			l_start: INTEGER
		do
			l_start := a_line.substring_index ("Feature:", 1)
			if l_start > 0 then
				l_start := l_start + 8  -- Length of "Feature:"
				if l_start <= a_line.count then
					Result := a_line.substring (l_start + 1, a_line.count).twin
					Result.left_adjust
					Result.right_adjust
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	extract_line_number (a_line: STRING_8): INTEGER
			-- Extract line number from "Line:" line
		require
			line_attached: a_line /= Void
		local
			l_start: INTEGER
			l_num_string: STRING_8
		do
			l_start := a_line.substring_index ("Line:", 1)
			if l_start > 0 then
				l_start := l_start + 5  -- Length of "Line:"
				if l_start <= a_line.count then
					l_num_string := a_line.substring (l_start + 1, a_line.count).twin
					l_num_string.left_adjust
					l_num_string.right_adjust
					
					if l_num_string.is_integer then
						Result := l_num_string.to_integer
					end
				end
			end
		ensure
			non_negative: Result >= 0
		end

	extract_file_path (a_line: STRING_8): STRING_8
			-- Extract file path from "File:" line
		require
			line_attached: a_line /= Void
		local
			l_start: INTEGER
		do
			l_start := a_line.substring_index ("File:", 1)
			if l_start > 0 then
				l_start := l_start + 5  -- Length of "File:"
				if l_start <= a_line.count then
					Result := a_line.substring (l_start + 1, a_line.count).twin
					Result.left_adjust
					Result.right_adjust
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation

	add_error_to_list (a_error: EM_ERROR)
			-- Add error to appropriate list
		require
			error_attached: a_error /= Void
		do
			if a_error.is_error then
				errors.extend (a_error)
			elseif a_error.is_warning then
				warnings.extend (a_error)
			end
		end

invariant
	errors_attached: errors /= Void
	warnings_attached: warnings /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
