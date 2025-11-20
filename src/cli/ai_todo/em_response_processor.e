note
	description: "[
		Processes responses from Claude received via Obsidian.
		
		Workflow:
		1. Watches in-from-AI folder for responses
		2. Validates response format (header comment with request ID)
		3. Copies files back to project
		4. Optionally triggers compilation/testing
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_RESPONSE_PROCESSOR

create
	make

feature {NONE} -- Initialization

	make (a_project_path, a_vault_path: READABLE_STRING_32)
			-- Initialize processor with project and vault paths
		require
			project_path_not_empty: not a_project_path.is_empty
			vault_path_not_empty: not a_vault_path.is_empty
		do
			create project_path.make_from_string (a_project_path)
			create bridge.make (a_vault_path)
			last_error := Void
		ensure
			project_path_set: project_path.same_string (a_project_path)
			bridge_created: bridge /= Void
		end

feature -- Access

	project_path: STRING_32
			-- Path to Eiffel project

	bridge: EM_OBSIDIAN_BRIDGE
			-- Bridge to Obsidian vault

	last_error: detachable STRING_32
			-- Last error message, if any

	last_processed_files: detachable ARRAYED_LIST [STRING_32]
			-- Files from last processed response

feature -- Operations

	check_for_response (a_request_id: READABLE_STRING_32): BOOLEAN
			-- Check if response exists for request
		require
			request_id_not_empty: not a_request_id.is_empty
		local
			l_files: ARRAYED_LIST [STRING_32]
		do
			last_error := Void

			l_files := bridge.watch_for_responses (a_request_id)
			Result := not l_files.is_empty
		end

	process_response (a_request_id: READABLE_STRING_32): BOOLEAN
			-- Process response for given request ID
			-- Returns True if successful
		require
			request_id_not_empty: not a_request_id.is_empty
		local
			l_response_files: ARRAYED_LIST [STRING_32]
			l_response_folder: STRING_32
		do
			last_error := Void
			last_processed_files := Void
			Result := False

			-- Get response files
			l_response_files := bridge.watch_for_responses (a_request_id)

			if l_response_files.is_empty then
				last_error := "No response files found for request: " + a_request_id
			else
				-- Build response folder path
				create l_response_folder.make_from_string (bridge.in_from_ai_folder)
				l_response_folder.append_character ('\')
				l_response_folder.append (a_request_id)

				-- Process each response file
				create last_processed_files.make (l_response_files.count)
				across l_response_files as ic loop
					if validate_and_copy_response (l_response_folder, ic, a_request_id) then
						if attached last_processed_files as al then
							al.extend (ic)
						else
							create last_processed_files.make (10)
							if attached last_processed_files as al then
								al.extend (ic)
							end
						end
					end
				end

				Result := attached last_processed_files as al and then not al.is_empty
			end
		ensure
			success_implies_files: Result implies last_processed_files /= Void
			failure_implies_error: not Result implies last_error /= Void
		end

feature {NONE} -- Implementation

	validate_and_copy_response (a_response_folder, a_filename, a_request_id: READABLE_STRING_32): BOOLEAN
			-- Validate response file has correct header and copy to project
		require
			response_folder_not_empty: not a_response_folder.is_empty
			filename_not_empty: not a_filename.is_empty
			request_id_not_empty: not a_request_id.is_empty
		local
			l_source_path: STRING_32
			l_target_path: STRING_32
			l_file: PLAIN_TEXT_FILE
			l_validated: BOOLEAN
		do
			Result := False

			-- Build source path
			create l_source_path.make_from_string (a_response_folder)
			l_source_path.append_character ('\')
			l_source_path.append (a_filename)

			-- Validate response header
			create l_file.make_with_name (l_source_path)
			if l_file.exists and then l_file.is_readable then
				l_validated := validate_response_header (l_file, a_request_id)

				if l_validated then
					-- Build target path
					create l_target_path.make_from_string (project_path)
					l_target_path.append_character ('\')
					l_target_path.append (a_filename)

					-- Copy file
					if copy_file (l_source_path, l_target_path) then
						Result := True
					else
						last_error := "Failed to copy file: " + a_filename
					end
				else
					last_error := "Invalid response header in: " + a_filename
				end
			else
				last_error := "Cannot read response file: " + a_filename
			end
		end

	validate_response_header (a_file: PLAIN_TEXT_FILE; a_request_id: READABLE_STRING_32): BOOLEAN
			-- Check if file has correct response header
		require
			file_attached: a_file /= Void
			file_readable: a_file.exists and then a_file.is_readable
			request_id_not_empty: not a_request_id.is_empty
		local
			l_line: STRING_32
			l_found: BOOLEAN
			l_max_lines: INTEGER
		do
			Result := False
			l_max_lines := 20  -- Check first 20 lines

			a_file.open_read

			from
				l_found := False
			until
				a_file.end_of_file or l_found or l_max_lines <= 0
			loop
				a_file.read_line
				l_line := a_file.last_string

				if l_line.has_substring ("RESPONSE_TO:") and then
				   l_line.has_substring (a_request_id) then
					l_found := True
					Result := True
				end

				l_max_lines := l_max_lines - 1
			end

			a_file.close
		end

	copy_file (a_source, a_target: READABLE_STRING_32): BOOLEAN
			-- Copy file from source to target
		require
			source_not_empty: not a_source.is_empty
			target_not_empty: not a_target.is_empty
		local
			l_source: PLAIN_TEXT_FILE
			l_target: PLAIN_TEXT_FILE
		do
			Result := False

			create l_source.make_with_name (a_source)
			if l_source.exists and then l_source.is_readable then
				create l_target.make_with_name (a_target)
				l_target.create_read_write

				l_source.open_read
				from
					l_source.start
				until
					l_source.end_of_file
				loop
					l_source.read_stream (4096)
					l_target.put_string (l_source.last_string)
				end
				l_source.close
				l_target.close

				Result := True
			end
		end

invariant
	project_path_not_empty: not project_path.is_empty
	bridge_attached: bridge /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
