note
	description: "[
		Orchestrates creation of AI-TODO request packages.
		
		Workflow:
		1. Scans project for AI-TODO items
		2. Creates request folder in Obsidian
		3. Copies relevant files
		4. Generates manifest
		5. Notifies user
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_REQUEST_PACKAGER

create
	make

feature {NONE} -- Initialization

	make (a_project_path, a_vault_path: READABLE_STRING_32)
			-- Initialize packager with project and vault paths
		require
			project_path_not_empty: not a_project_path.is_empty
			vault_path_not_empty: not a_vault_path.is_empty
		do
			create scanner.make_with_project_path (a_project_path)
			create bridge.make (a_vault_path)
			last_request_id := Void
			last_error := Void
		ensure
			scanner_created: scanner /= Void
			bridge_created: bridge /= Void
		end

feature -- Access

	scanner: EM_AI_TODO_SCANNER
			-- Scanner for finding AI-TODO items

	bridge: EM_OBSIDIAN_BRIDGE
			-- Bridge to Obsidian vault

	last_request_id: detachable STRING_32
			-- ID of last created request

	last_error: detachable STRING_32
			-- Last error message, if any

feature -- Operations

	create_request_package: BOOLEAN
			-- Create complete request package
			-- Returns True if successful
		local
			l_request_id: STRING_32
			l_request_folder: STRING_32
			l_manifest: EM_REQUEST_MANIFEST
			l_files_to_copy: HASH_TABLE [STRING_32, STRING_32]
		do
			last_error := Void
			Result := False

			-- Ensure Obsidian folders exist
			bridge.ensure_folders_exist

			if not bridge.has_out_folder or not bridge.has_in_folder then
				last_error := "Failed to create Obsidian folders"
			else
				-- Scan for TODO items
				scanner.scan_for_todos

				if scanner.last_scan_results.is_empty then
					if attached scanner.last_error as l_err then
						last_error := l_err
					else
						last_error := "No AI-TODO items found"
					end
				else
					-- Generate unique request ID
					l_request_id := generate_request_id

					-- Create request folder
					l_request_folder := bridge.create_request_folder (l_request_id)

					-- Build list of unique files to copy
					create l_files_to_copy.make (scanner.last_scan_results.count)
					across scanner.last_scan_results as ic loop
						l_files_to_copy.force (ic.file_path, ic.file_path)
					end

					-- Copy files to request folder
					across l_files_to_copy as ic loop
						bridge.copy_file_to_request (ic, l_request_folder)
					end

					-- Create and write manifest
					create l_manifest.make (l_request_id)
					across l_files_to_copy as ic loop
						l_manifest.add_file (ic)
					end
					across scanner.last_scan_results as ic loop
						l_manifest.add_todo_item (ic)
					end

					bridge.write_manifest (l_manifest, l_request_folder)

					-- Success
					last_request_id := l_request_id
					Result := True
				end
			end
		ensure
			success_implies_request_id: Result implies last_request_id /= Void
			failure_implies_error: not Result implies last_error /= Void
		end

	create_package_for_files (a_files: ARRAYED_LIST [STRING_32]): BOOLEAN
			-- Create request package for specific files only
		require
			files_not_empty: not a_files.is_empty
		local
			l_request_id: STRING_32
			l_request_folder: STRING_32
			l_manifest: EM_REQUEST_MANIFEST
			l_all_todos: ARRAYED_LIST [EM_AI_TODO_ITEM]
		do
			last_error := Void
			Result := False

			-- Ensure Obsidian folders exist
			bridge.ensure_folders_exist

			if not bridge.has_out_folder or not bridge.has_in_folder then
				last_error := "Failed to create Obsidian folders"
			else
				-- Scan each specified file
				create l_all_todos.make (10)
				across a_files as ic loop
					scanner.scan_file (ic)
					across scanner.last_scan_results as ic_todo loop
						l_all_todos.extend (ic_todo)
					end
				end

				if l_all_todos.is_empty then
					last_error := "No AI-TODO items found in specified files"
				else
					-- Generate request ID
					l_request_id := generate_request_id

					-- Create request folder
					l_request_folder := bridge.create_request_folder (l_request_id)

					-- Copy specified files
					across a_files as ic loop
						bridge.copy_file_to_request (ic, l_request_folder)
					end

					-- Create and write manifest
					create l_manifest.make (l_request_id)
					across a_files as ic loop
						l_manifest.add_file (ic)
					end
					across l_all_todos as ic loop
						l_manifest.add_todo_item (ic)
					end

					bridge.write_manifest (l_manifest, l_request_folder)

					-- Success
					last_request_id := l_request_id
					Result := True
				end
			end
		ensure
			success_implies_request_id: Result implies last_request_id /= Void
			failure_implies_error: not Result implies last_error /= Void
		end

feature {NONE} -- Implementation

	generate_request_id: STRING_32
			-- Generate unique request ID
		local
			l_date_time: DATE_TIME
		do
			create l_date_time.make_now

			Result := "req_" + l_date_time.out.to_string_32
		ensure
			result_not_empty: not Result.is_empty
			result_starts_with_req: Result.starts_with ("req_")
		end

invariant
	scanner_attached: scanner /= Void
	bridge_attached: bridge /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
