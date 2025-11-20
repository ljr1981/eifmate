note
	description: "[
		End-to-end test for AI-TODO workflow using MOCK_01.
		
		Tests complete cycle:
		1. Package MOCK_01 with AI-TODOs
		2. Generate Obsidian request
		3. Validate manifest and files
		4. (Manual) Process in Obsidian with Claude
		5. (Future) Validate response integration
	]"
	testing: "type/manual"

class
	TEST_EM_AI_TODO_WORKFLOW

inherit
	TEST_SET_BASE_WITH_CONSTANTS

feature -- Test routines

	test_scan_finds_mock_01
	        -- Test scanner finds MOCK_01.e with its 2 AI-TODOs
	    note
	        testing: "covers/{EM_AI_TODO_SCANNER}.scan_for_todos"
	    local
	        l_scanner: EM_AI_TODO_SCANNER
	        l_mock_path: STRING_32
	    do
	        -- Point to testing/cli/mocks folder
	        create l_mock_path.make_from_string (test_project_root)
	        l_mock_path.append ("\testing\cli\mocks")

	        create l_scanner.make_with_project_path (l_mock_path)
	        l_scanner.scan_for_todos

	        assert ("found_todos", not l_scanner.last_scan_results.is_empty)
	        assert ("found_two_todos", l_scanner.last_scan_results.count = 2)

	        -- Verify both TODOs are from mock_01.e
	        across l_scanner.last_scan_results as ic loop
	            assert ("from_mock_01", ic.file_path.has_substring ("mock_01.e"))
	        end
	    end

	test_create_mock_01_request_package
			-- Test creating request package for MOCK_01
		note
			testing: "covers/{EM_REQUEST_PACKAGER}.create_request_package"
		local
			l_packager: EM_REQUEST_PACKAGER
			l_success: BOOLEAN
			l_request_id: detachable STRING_32
		do
			-- Initialize packager with test paths
			create l_packager.make (test_project_root, obsidian_path)

			-- Create request package
			l_success := l_packager.create_request_package

			-- Validate results
			assert ("package_created", l_success)
			assert ("has_request_id", l_packager.last_request_id /= Void)
			assert ("no_error", l_packager.last_error = Void)

			if attached l_packager.last_request_id as al_id then
				l_request_id := al_id
				print ("%N" + "Request package created: " + al_id + "%N")
				print ("Location: " + obsidian_path + "\out-to-AI\" + al_id + "%N")
			end

			-- Validate scanner found MOCK_01 TODOs
			assert ("scanner_found_todos",
					not l_packager.scanner.last_scan_results.is_empty)
			assert ("found_two_todos",
					l_packager.scanner.last_scan_results.count = 2)
		end

	test_validate_mock_01_manifest
			-- Test that manifest correctly documents MOCK_01 TODOs
		note
			testing: "covers/{EM_REQUEST_MANIFEST}"
		local
			l_packager: EM_REQUEST_PACKAGER
			l_manifest_path: STRING_32
			l_file: PLAIN_TEXT_FILE
			l_content: STRING_32
		do
			-- Create request package first
			create l_packager.make (test_project_root, obsidian_path)
			if l_packager.create_request_package then
				if attached l_packager.last_request_id as al_id then
					-- Build manifest path
					create l_manifest_path.make_from_string (obsidian_path)
					l_manifest_path.append ("\out-to-AI\")
					l_manifest_path.append (al_id)
					l_manifest_path.append ("\REQUEST.md")

					-- Read manifest
					create l_file.make_with_name (l_manifest_path)
					if l_file.exists and then l_file.is_readable then
						l_file.open_read
						create l_content.make (l_file.count)
						l_file.read_stream (l_file.count)
						l_content := l_file.last_string
						l_file.close

						-- Validate manifest content
						assert ("has_request_header",
        						l_content.has_substring ("EifMate Request Manifest"))
						assert ("has_request_id",
								l_content.has_substring (al_id))
						assert ("has_mock_file",
								l_content.has_substring ("mock_01.e"))
						assert ("has_name_todo",
								l_content.has_substring ("create a `name' feature"))
						assert ("has_contract_todo",
								l_content.has_substring ("design-by-contract"))
					else
						assert ("manifest_exists", False)
					end
				else
					assert ("request_id_attached", False)
				end
			else
				assert ("package_created", False)
			end
		end

	test_mock_01_file_copied
			-- Test that MOCK_01.e was copied to request folder
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.copy_file_to_request"
		local
			l_packager: EM_REQUEST_PACKAGER
			l_mock_path: STRING_32
			l_file: PLAIN_TEXT_FILE
		do
			-- Create request package
			create l_packager.make (test_project_root, obsidian_path)
			if l_packager.create_request_package then
				if attached l_packager.last_request_id as al_id then
					-- Build mock file path in request folder
					create l_mock_path.make_from_string (obsidian_path)
					l_mock_path.append ("\out-to-AI\")
					l_mock_path.append (al_id)
					l_mock_path.append ("\mock_01.e")

					-- Validate file exists
					create l_file.make_with_name (l_mock_path)
					assert ("mock_file_exists", l_file.exists)
					assert ("mock_file_readable", l_file.is_readable)
				else
					assert ("request_id_attached", False)
				end
			else
				assert ("package_created", False)
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
