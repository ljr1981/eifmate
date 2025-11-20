note
	description: "Tests for {EM_OBSIDIAN_BRIDGE} with response file handling."
	testing: "type/manual", "execution/serial"

class
	TEST_EM_OBSIDIAN_BRIDGE

inherit
	TEST_SET_BASE_WITH_CONSTANTS
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Setup/Teardown

	on_prepare
			-- Create test response files before tests run
		do
			Precursor
			create_test_response_files
		end

	on_clean
			-- Clean up test artifacts
		do
			Precursor
			cleanup_test_folders
		end

feature -- Test routines - Bridge

	test_bridge_initialization
			-- Test bridge creates properly with config path
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.make"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
		do
			create l_bridge.make (Obsidian_path)
			assert ("bridge_created", l_bridge /= Void)
			assert ("vault_path_set", l_bridge.vault_path.same_string (Obsidian_path))
			assert ("out_folder_set", l_bridge.out_to_ai_folder.has_substring ("out-to-AI"))
			assert ("in_folder_set", l_bridge.in_from_ai_folder.has_substring ("in-from-AI"))
		end

	test_folder_paths
			-- Test folder path construction with config
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.make"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
			l_expected_out, l_expected_in: STRING_32
		do
			create l_bridge.make (Obsidian_path)
			
			create l_expected_out.make_from_string (Obsidian_path)
			l_expected_out.append ("\out-to-AI")
			
			create l_expected_in.make_from_string (Obsidian_path)
			l_expected_in.append ("\in-from-AI")
			
			assert ("out_path_correct", l_bridge.out_to_ai_folder.same_string (l_expected_out))
			assert ("in_path_correct", l_bridge.in_from_ai_folder.same_string (l_expected_in))
		end

	test_vault_accessibility
			-- Test if vault is accessible
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.is_vault_accessible"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
		do
			create l_bridge.make (Obsidian_path)
			assert ("vault_accessible", l_bridge.is_vault_accessible)
		end

	test_ensure_folders_exist
			-- Test creating out-to-AI and in-from-AI folders
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.ensure_folders_exist"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
		do
			create l_bridge.make (Obsidian_path)
			l_bridge.ensure_folders_exist
			assert ("out_folder_exists", l_bridge.has_out_folder)
			assert ("in_folder_exists", l_bridge.has_in_folder)
		end

feature -- Test routines - Requests

	test_create_request_folder
			-- Test creating request-specific folder
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.create_request_folder"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
			l_request_id: STRING_32
			l_folder_path: STRING_32
			l_dir: DIRECTORY
		do
			create l_bridge.make (Obsidian_path)
			l_bridge.ensure_folders_exist
			
			l_request_id := "test_req_001"
			l_folder_path := l_bridge.create_request_folder (l_request_id)
			
			assert ("folder_path_not_empty", not l_folder_path.is_empty)
			create l_dir.make (l_folder_path)
			assert ("folder_exists", l_dir.exists)
		end

	test_write_manifest
			-- Test writing manifest to request folder
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.write_manifest"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
			l_manifest: EM_REQUEST_MANIFEST
			l_request_id: STRING_32
			l_folder_path: STRING_32
			l_file: PLAIN_TEXT_FILE
			l_manifest_path: STRING_32
		do
			create l_bridge.make (Obsidian_path)
			l_bridge.ensure_folders_exist
			
			l_request_id := "test_req_002"
			l_folder_path := l_bridge.create_request_folder (l_request_id)
			
			create l_manifest.make (l_request_id)
			l_manifest.add_file ("test.e")
			l_bridge.write_manifest (l_manifest, l_folder_path)
			
			create l_manifest_path.make_from_string (l_folder_path)
			l_manifest_path.append ("\REQUEST.md")
			create l_file.make_with_name (l_manifest_path)
			assert ("manifest_file_exists", l_file.exists)
		end

	test_copy_file_to_request
			-- Test copying file to request folder
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.copy_file_to_request"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
			l_request_id: STRING_32
			l_folder_path: STRING_32
			l_source_file: PLAIN_TEXT_FILE
			l_target_file: PLAIN_TEXT_FILE
			l_source_path, l_target_path: STRING_32
		do
			create l_bridge.make (Obsidian_path)
			l_bridge.ensure_folders_exist
			
			-- Create dummy source file
			create l_source_path.make_from_string (Test_project_root)
			l_source_path.append ("\test_dummy.e")
			create l_source_file.make_with_name (l_source_path)
			l_source_file.create_read_write
			l_source_file.put_string ("-- Test content")
			l_source_file.close
			
			-- Copy to request folder
			l_request_id := "test_req_003"
			l_folder_path := l_bridge.create_request_folder (l_request_id)
			l_bridge.copy_file_to_request (l_source_path, l_folder_path)
			
			-- Verify copied
			create l_target_path.make_from_string (l_folder_path)
			l_target_path.append ("\test_dummy.e")
			create l_target_file.make_with_name (l_target_path)
			assert ("target_file_exists", l_target_file.exists)
			
			-- Cleanup source
			l_source_file.delete
		end

feature -- Test routines - Responses

	test_watch_for_responses
			-- Test watching for response files
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.watch_for_responses"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
			l_responses: ARRAYED_LIST [STRING_32]
		do
			create l_bridge.make (Obsidian_path)
			l_responses := l_bridge.watch_for_responses ("test_req_response_001")
			assert ("found_response_file", not l_responses.is_empty)
			assert ("correct_filename", l_responses.first.has_substring ("test_response.e"))
		end

	test_response_file_has_header
			-- Test response file contains RESPONSE_TO header
		note
			testing: "covers/{EM_RESPONSE_PROCESSOR}.validate_and_copy_response"
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING_32
			l_path: STRING_32
		do
			create l_path.make_from_string (Obsidian_path)
			l_path.append ("\in-from-AI\test_req_response_001\test_response.e")
			
			create l_file.make_with_name (l_path)
			l_file.open_read
			create l_content.make_empty
			from l_file.start until l_file.end_of_file loop
				l_file.read_stream (1024)
				l_content.append (l_file.last_string)
			end
			l_file.close
			
			assert ("has_response_to_header", l_content.has_substring ("RESPONSE_TO: test_req_response_001"))
		end

feature -- Test routines - Manifest

	test_request_manifest
			-- Test manifest creation
		note
			testing: "covers/{EM_REQUEST_MANIFEST}.make"
		local
			l_manifest: EM_REQUEST_MANIFEST
		do
			create l_manifest.make ("req_001")
			assert ("manifest_created", l_manifest /= Void)
			assert ("request_id_set", l_manifest.request_id.same_string ("req_001"))
			assert ("files_empty", l_manifest.files.is_empty)
			assert ("todos_empty", l_manifest.todo_items.is_empty)
		end

	test_manifest_add_file
			-- Test adding file to manifest
		note
			testing: "covers/{EM_REQUEST_MANIFEST}.add_file"
		local
			l_manifest: EM_REQUEST_MANIFEST
		do
			create l_manifest.make ("req_002")
			l_manifest.add_file ("test1.e")
			l_manifest.add_file ("test2.e")
			assert ("two_files", l_manifest.files.count = 2)
		end

	test_manifest_add_todo
			-- Test adding TODO to manifest
		note
			testing: "covers/{EM_REQUEST_MANIFEST}.add_todo_item"
		local
			l_manifest: EM_REQUEST_MANIFEST
			l_item: EM_AI_TODO_ITEM
		do
			create l_manifest.make ("req_003")
			create l_item.make ("test.e", 5, "Fix this")
			l_manifest.add_todo_item (l_item)
			assert ("one_todo", l_manifest.todo_items.count = 1)
		end

	test_manifest_to_markdown
			-- Test manifest markdown generation
		note
			testing: "covers/{EM_REQUEST_MANIFEST}.to_markdown"
		local
			l_manifest: EM_REQUEST_MANIFEST
			l_item: EM_AI_TODO_ITEM
			l_markdown: STRING_32
		do
			create l_manifest.make ("req_004")
			l_manifest.add_file ("my_class.e")
			create l_item.make ("my_class.e", 10, "Implement feature_x")
			l_manifest.add_todo_item (l_item)

			l_markdown := l_manifest.to_markdown
			assert ("markdown_not_empty", not l_markdown.is_empty)
			assert ("has_request_id", l_markdown.has_substring ("req_004"))
			assert ("has_file", l_markdown.has_substring ("my_class.e"))
			assert ("has_todo_text", l_markdown.has_substring ("Implement feature_x"))
			assert ("has_instructions", l_markdown.has_substring ("Instructions for Claude"))
		end

feature {NONE} -- Setup helpers

	create_test_response_files
			-- Create dummy response files for testing
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
			l_request_id: STRING_32
			l_folder_path: STRING_32
			l_dir: DIRECTORY
			l_file: PLAIN_TEXT_FILE
			l_response_path: STRING_32
		do
			create l_bridge.make (Obsidian_path)
			l_bridge.ensure_folders_exist
			
			-- Create test response folder
			l_request_id := "test_req_response_001"
			create l_folder_path.make_from_string (l_bridge.in_from_ai_folder)
			l_folder_path.append_character ('\')
			l_folder_path.append (l_request_id)
			
			create l_dir.make (l_folder_path)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end
			
			-- Create dummy response file (overwrite if exists)
			create l_response_path.make_from_string (l_folder_path)
			l_response_path.append ("\test_response.e")
			create l_file.make_with_name (l_response_path)
			if l_file.exists then
				l_file.delete
			end
			l_file.create_read_write
			l_file.put_string ("-- RESPONSE_TO: test_req_response_001%N")
			l_file.put_string ("-- Test response content%N")
			l_file.close
		end

feature {NONE} -- Cleanup

	cleanup_test_folders
			-- Delete all test request and response folders
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
		do
			create l_bridge.make (Obsidian_path)
			cleanup_folder (l_bridge.out_to_ai_folder, "test_req_")
			cleanup_folder (l_bridge.in_from_ai_folder, "test_req_")
		end

	cleanup_folder (a_folder: STRING_32; a_prefix: STRING_32)
			-- Delete all folders starting with a_prefix from a_folder
		local
			l_dir: DIRECTORY
			l_entries: ARRAYED_LIST [PATH]
		do
			create l_dir.make (a_folder)
			if l_dir.exists then
				l_entries := l_dir.entries
				across l_entries as ic loop
					if ic.name.out.starts_with (a_prefix) then
						delete_directory_recursive (a_folder + "\" + ic.name.out)
					end
				end
			end
		end

	delete_directory_recursive (a_path: STRING_32)
			-- Recursively delete directory and contents
		local
			l_dir: DIRECTORY
			l_entries: ARRAYED_LIST [PATH]
			l_file: PLAIN_TEXT_FILE
			l_full_path: STRING_32
		do
			create l_dir.make (a_path)
			if l_dir.exists then
				l_entries := l_dir.entries
				across l_entries as ic loop
					if not ic.name.out.same_string (".") and not ic.name.out.same_string ("..") then
						create l_full_path.make_from_string (a_path)
						l_full_path.append_character ('\')
						l_full_path.append (ic.name.out)
						
						create l_dir.make (l_full_path)
						if l_dir.exists then
							delete_directory_recursive (l_full_path)
						else
							create l_file.make_with_name (l_full_path)
							if l_file.exists then
								l_file.delete
							end
						end
					end
				end
				create l_dir.make (a_path)
				l_dir.delete
			end
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
