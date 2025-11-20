note
	description: "Tests for {EM_OBSIDIAN_BRIDGE}."
	testing: "type/manual"

class
	TEST_EM_OBSIDIAN_BRIDGE

inherit
	EQA_TEST_SET

feature -- Test routines

	test_bridge_initialization
			-- Test bridge creates properly
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.make"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
		do
			create l_bridge.make ("C:\vault")
			assert ("bridge_created", l_bridge /= Void)
			assert ("vault_path_set", l_bridge.vault_path.same_string ("C:\vault"))
			assert ("out_folder_set", l_bridge.out_to_ai_folder.has_substring ("out-to-AI"))
			assert ("in_folder_set", l_bridge.in_from_ai_folder.has_substring ("in-from-AI"))
		end

	test_folder_paths
			-- Test folder path construction
		note
			testing: "covers/{EM_OBSIDIAN_BRIDGE}.make"
		local
			l_bridge: EM_OBSIDIAN_BRIDGE
		do
			create l_bridge.make ("C:\vault")
			assert ("out_path_correct", 
					l_bridge.out_to_ai_folder.same_string ("C:\vault\out-to-AI"))
			assert ("in_path_correct", 
					l_bridge.in_from_ai_folder.same_string ("C:\vault\in-from-AI"))
		end

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

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
