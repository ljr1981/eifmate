note
	description: "[
		Bridge to Obsidian vault for AI-TODO workflow.
		
		Manages:
		- out-to-AI folder (requests to Claude)
		- in-from-AI folder (responses from Claude)
		- File copying and organization
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_OBSIDIAN_BRIDGE

create
	make

feature {NONE} -- Initialization

	make (a_vault_path: READABLE_STRING_32)
			-- Initialize with Obsidian vault path
		require
			vault_path_not_empty: not a_vault_path.is_empty
		do
			create vault_path.make_from_string (a_vault_path)
			create out_to_ai_folder.make_from_string (vault_path)
			out_to_ai_folder.append ("\out-to-AI")
			create in_from_ai_folder.make_from_string (vault_path)
			in_from_ai_folder.append ("\in-from-AI")
			last_error := Void
		ensure
			vault_path_set: vault_path.same_string (a_vault_path)
		end

feature -- Access

	vault_path: STRING_32
			-- Path to Obsidian vault

	out_to_ai_folder: STRING_32
			-- Folder for outgoing requests to Claude

	in_from_ai_folder: STRING_32
			-- Folder for incoming responses from Claude

	last_error: detachable STRING_32
			-- Last error message, if any

feature -- Status report

	is_vault_accessible: BOOLEAN
			-- Can we access the vault?
		local
			l_dir: DIRECTORY
		do
			create l_dir.make (vault_path)
			Result := l_dir.exists
		end

	has_out_folder: BOOLEAN
			-- Does out-to-AI folder exist?
		local
			l_dir: DIRECTORY
		do
			create l_dir.make (out_to_ai_folder)
			Result := l_dir.exists
		end

	has_in_folder: BOOLEAN
			-- Does in-from-AI folder exist?
		local
			l_dir: DIRECTORY
		do
			create l_dir.make (in_from_ai_folder)
			Result := l_dir.exists
		end

feature -- Operations

	ensure_folders_exist
			-- Create out-to-AI and in-from-AI folders if needed
		local
			l_dir: DIRECTORY
		do
			last_error := Void

			-- Create out-to-AI folder
			if not has_out_folder then
				create l_dir.make (out_to_ai_folder)
				l_dir.create_dir
			end

			-- Create in-from-AI folder
			if not has_in_folder then
				create l_dir.make (in_from_ai_folder)
				l_dir.create_dir
			end
		ensure
			folders_exist: has_out_folder and has_in_folder
		end

	create_request_folder (a_request_id: READABLE_STRING_32): STRING_32
			-- Create folder for specific request in out-to-AI
		require
			request_id_not_empty: not a_request_id.is_empty
			out_folder_exists: has_out_folder
		local
			l_dir: DIRECTORY
		do
			create Result.make_from_string (out_to_ai_folder)
			Result.append_character ('\')
			Result.append (a_request_id)

			create l_dir.make (Result)
			if not l_dir.exists then
				l_dir.create_dir
			end
		ensure
			result_not_empty: not Result.is_empty
		end

	copy_file_to_request (a_source_path, a_request_folder: READABLE_STRING_32)
			-- Copy file to request folder
		require
			source_not_empty: not a_source_path.is_empty
			request_folder_not_empty: not a_request_folder.is_empty
		local
			l_source: PLAIN_TEXT_FILE
			l_target: PLAIN_TEXT_FILE
			l_target_path: STRING_32
			l_file_name: STRING_32
		do
			last_error := Void

			-- Extract filename from path
			l_file_name := extract_filename (a_source_path)

			-- Build target path
			create l_target_path.make_from_string (a_request_folder)
			l_target_path.append_character ('\')
			l_target_path.append (l_file_name)

			-- Copy file
			create l_source.make_with_name (a_source_path)
			if l_source.exists and then l_source.is_readable then
				create l_target.make_with_name (l_target_path)
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
			else
				create last_error.make_from_string ("Cannot read source file: ")
				if attached last_error as al_last_error then
					al_last_error.append (a_source_path)
				else
					last_error := a_source_path.twin
				end
			end
		end

	write_manifest (a_manifest: EM_REQUEST_MANIFEST; a_request_folder: READABLE_STRING_32)
			-- Write manifest file to request folder
		require
			manifest_attached: a_manifest /= Void
			request_folder_not_empty: not a_request_folder.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_path: STRING_32
			l_content: STRING_32
		do
			last_error := Void

			create l_path.make_from_string (a_request_folder)
			l_path.append ("\REQUEST.md")

			create l_file.make_with_name (l_path)
			l_file.create_read_write
			l_content := a_manifest.to_markdown
			l_file.put_string (l_content)
			l_file.close
		end

	watch_for_responses (a_request_id: READABLE_STRING_32): ARRAYED_LIST [STRING_32]
			-- Check for response files for given request
		require
			request_id_not_empty: not a_request_id.is_empty
			in_folder_exists: has_in_folder
		local
			l_response_folder: STRING_32
			l_dir: DIRECTORY
			l_entries: ARRAYED_LIST [PATH]
		do
			create Result.make (5)

			create l_response_folder.make_from_string (in_from_ai_folder)
			l_response_folder.append_character ('\')
			l_response_folder.append (a_request_id)

			create l_dir.make (l_response_folder)
			if l_dir.exists then
				l_entries := l_dir.entries
				across l_entries as ic loop
					if ic.name.ends_with (".e") then
						Result.extend (ic.name.out)
					end
				end
			end
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation

	extract_filename (a_path: READABLE_STRING_32): STRING_32
			-- Extract filename from full path
		require
			path_not_empty: not a_path.is_empty
		local
			l_last_slash: INTEGER
		do
			l_last_slash := a_path.last_index_of ('\', a_path.count)
			if l_last_slash = 0 then
				l_last_slash := a_path.last_index_of ('/', a_path.count)
			end

			if l_last_slash > 0 and then l_last_slash < a_path.count then
				Result := a_path.substring (l_last_slash + 1, a_path.count)
			else
				create Result.make_from_string (a_path)
			end
		ensure
			result_not_empty: not Result.is_empty
		end

invariant
	vault_path_not_empty: not vault_path.is_empty
	out_folder_not_empty: not out_to_ai_folder.is_empty
	in_folder_not_empty: not in_from_ai_folder.is_empty

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
