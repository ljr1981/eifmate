note
	description: "[
		Scans Eiffel source files for AI-TODO comments using Windows findstr.
		
		Finds comments containing 'AI-TODO' marker:
		- In single-line comments: -- AI-TODO: ...
		- In note clauses: note AI-TODO: "..."
		
		Uses Windows findstr command for efficient file scanning.
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_AI_TODO_SCANNER

create
	make,
	make_with_project_path

feature {NONE} -- Initialization

	make
			-- Initialize scanner with current directory
		do
			create project_path.make_from_string (".")
			create last_scan_results.make (10)
		ensure
			project_path_set: not project_path.is_empty
			results_initialized: last_scan_results.is_empty
		end

	make_with_project_path (a_path: READABLE_STRING_32)
			-- Initialize scanner with specific project directory
		require
			path_not_empty: not a_path.is_empty
		do
			create project_path.make_from_string (a_path)
			create last_scan_results.make (10)
		ensure
			project_path_set: project_path.same_string (a_path)
			results_initialized: last_scan_results.is_empty
		end

feature -- Access

	project_path: STRING_32
			-- Root path to scan for files

	last_scan_results: ARRAYED_LIST [EM_AI_TODO_ITEM]
			-- Results from most recent scan

	last_error: detachable STRING_32
			-- Error message from last operation, if any

feature -- Operations

	scan_for_todos
			-- Scan project for all AI-TODO items
		local
			l_files: ARRAYED_LIST [STRING_32]
		do
			last_scan_results.wipe_out
			last_error := Void

			-- Find all files with AI-TODO markers
			l_files := find_files_with_todos

			if l_files.is_empty and attached last_error then
				-- Error occurred during file search
			else
				-- Parse each file for TODO items
				across l_files as ic loop
					parse_file_for_todos (ic)
				end
			end
		ensure
			results_cleared_on_start: True
		end

	scan_file (a_file_path: READABLE_STRING_32)
			-- Scan specific file for AI-TODO items
		require
			file_path_not_empty: not a_file_path.is_empty
		do
			last_scan_results.wipe_out
			last_error := Void
			parse_file_for_todos (a_file_path)
		end

feature {NONE} -- Implementation

	find_files_with_todos: ARRAYED_LIST [STRING_32]
			-- Use findstr to locate files containing AI-TODO
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			l_cmd: STRING_32
			l_output: STRING_32
			l_lines: LIST [STRING_32]
			l_buffer: SPECIAL [NATURAL_8]
			l_chunk: STRING_32
		do
			create Result.make (10)

			-- Build findstr command
			create l_cmd.make (128)
			l_cmd.append ("cmd /c %"cd /d ")
			l_cmd.append (project_path)
			l_cmd.append (" && findstr /S /M /C:%"AI-TODO%" *.e%"")

			-- Create process using factory
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (
				l_cmd,
				Void  -- Use current directory
			)

			-- Configure process
			l_process.set_hidden (True)
			l_process.redirect_output_to_stream
			l_process.redirect_error_to_same_as_output

			-- Launch and capture output
			l_process.launch

			if l_process.launched then
				create l_output.make_empty

				-- Read output in chunks
				from
					create l_buffer.make_filled (0, 1024)
				until
					l_process.has_output_stream_closed or else
					l_process.has_output_stream_error
				loop
					l_buffer := l_buffer.aliased_resized_area_with_default (0, l_buffer.capacity)
					l_process.read_output_to_special (l_buffer)

					if l_buffer.count > 0 then
						l_chunk := converter.console_encoding_to_utf32 (
							console_encoding,
							create {STRING_8}.make_from_c_substring ($l_buffer, 1, l_buffer.count))
						l_chunk.prune_all ({CHARACTER_32} '%R')
						l_output.append (l_chunk)
					end
				end

				l_process.wait_for_exit

				if l_process.exit_code = 0 then
					-- Success - parse output
					l_lines := l_output.split ('%N')

					across l_lines as ic loop
						if not ic.is_empty then
							Result.extend (ic.twin)
						end
					end
				else
					-- Findstr exit code 1 = no matches (not an error)
					-- Only capture error for actual failures
					if l_process.exit_code > 1 then
						create last_error.make_from_string (l_output)
					end
				end
			else
				create last_error.make_from_string ("Failed to launch findstr command")
			end
		ensure
			result_attached: Result /= Void
		end

	parse_file_for_todos (a_file_path: READABLE_STRING_32)
			-- Parse single file for AI-TODO items
		require
			file_path_not_empty: not a_file_path.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING_32
			l_line_number: INTEGER
			l_todo_item: EM_AI_TODO_ITEM
		do
			create l_file.make_with_name (a_file_path)

			if l_file.exists and then l_file.is_readable then
				l_file.open_read

				from
					l_line_number := 1
				until
					l_file.end_of_file
				loop
					l_file.read_line
					l_line := l_file.last_string

					if contains_ai_todo (l_line) then
						l_todo_item := extract_todo_item (a_file_path, l_line_number, l_line)
						last_scan_results.extend (l_todo_item)
					end

					l_line_number := l_line_number + 1
				end

				l_file.close
			else
				-- File not accessible
				if last_error = Void then
					create last_error.make_from_string ("Cannot read file: ")
					if attached last_error as al then
						al.append (a_file_path)
					end
				end
			end
		end

	contains_ai_todo (a_line: STRING_32): BOOLEAN
			-- Does line contain AI-TODO marker?
		do
			Result := a_line.has_substring ("AI-TODO")
		end

	extract_todo_item (a_file: READABLE_STRING_32; a_line_num: INTEGER;
					   a_line: STRING_32): EM_AI_TODO_ITEM
			-- Extract TODO item from line
		require
			file_not_empty: not a_file.is_empty
			line_num_positive: a_line_num > 0
			line_has_todo: contains_ai_todo (a_line)
		local
			l_text: STRING_32
			l_scope: INTEGER
			l_start_pos: INTEGER
		do
			-- Extract TODO text (everything after AI-TODO:)
			l_start_pos := a_line.substring_index ("AI-TODO", 1)
			if l_start_pos > 0 then
				l_text := a_line.substring (l_start_pos + 7, a_line.count)
				l_text.left_adjust
				l_text.right_adjust

				-- Remove leading colon if present
				if not l_text.is_empty and then l_text.item (1) = ':' then
					l_text := l_text.substring (2, l_text.count)
					l_text.left_adjust
				end

				-- Detect scope based on line content
				l_scope := detect_scope (a_line)

				create Result.make_with_scope (a_file, a_line_num, l_text, l_scope)
			else
				-- Shouldn't reach here due to precondition
				create Result.make (a_file, a_line_num, a_line)
			end
		ensure
			result_attached: Result /= Void
		end

	detect_scope (a_line: STRING_32): INTEGER
			-- Detect TODO scope from line context
		do
			-- Simple heuristic based on line content
			if a_line.has_substring ("note") and then
			   a_line.has_substring ("class") then
				Result := {EM_AI_TODO_ITEM}.Scope_class
			elseif a_line.has_substring ("feature") then
				Result := {EM_AI_TODO_ITEM}.Scope_feature
			else
				Result := {EM_AI_TODO_ITEM}.Scope_line
			end
		ensure
			valid_scope: Result >= {EM_AI_TODO_ITEM}.Scope_line and
						 Result <= {EM_AI_TODO_ITEM}.Scope_class
		end

feature {NONE} -- Implementation

	converter: LOCALIZED_PRINTER
			-- Encoding converter helper.
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	console_encoding: ENCODING
			-- Current console encoding.
		local
			l_system_encodings: SYSTEM_ENCODINGS
		once
			create l_system_encodings
			Result := l_system_encodings.console_encoding
		ensure
			result_attached: Result /= Void
		end

invariant
	project_path_not_empty: not project_path.is_empty
	results_attached: last_scan_results /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
