note
	description: "Tests for {EM_AI_TODO_SCANNER}."
	testing: "type/manual"

class
	TEST_EM_AI_TODO_SCANNER

inherit
	EQA_TEST_SET

feature -- Test routines

	test_scanner_initialization
			-- Test scanner creates properly
		note
			testing: "covers/{EM_AI_TODO_SCANNER}.make"
		local
			l_scanner: EM_AI_TODO_SCANNER
		do
			create l_scanner.make
			assert ("scanner_created", l_scanner /= Void)
			assert ("results_empty", l_scanner.last_scan_results.is_empty)
		end

	test_scanner_with_path
			-- Test scanner with specific path
		note
			testing: "covers/{EM_AI_TODO_SCANNER}.make_with_project_path"
		local
			l_scanner: EM_AI_TODO_SCANNER
			l_path: STRING_32
		do
			create l_path.make_from_string ("C:\test\project")
			create l_scanner.make_with_project_path (l_path)
			assert ("scanner_created", l_scanner /= Void)
			assert ("path_set", l_scanner.project_path.same_string (l_path))
		end

	test_todo_item_creation
			-- Test creating TODO item
		note
			testing: "covers/{EM_AI_TODO_ITEM}.make"
		local
			l_item: EM_AI_TODO_ITEM
		do
			create l_item.make ("test.e", 42, "Implement feature")
			assert ("item_created", l_item /= Void)
			assert ("file_path_set", l_item.file_path.same_string ("test.e"))
			assert ("line_number_set", l_item.line_number = 42)
			assert ("text_set", l_item.todo_text.same_string ("Implement feature"))
			assert ("default_scope", l_item.is_line_scope)
		end

	test_todo_item_with_scope
			-- Test creating TODO item with explicit scope
		note
			testing: "covers/{EM_AI_TODO_ITEM}.make_with_scope"
		local
			l_item: EM_AI_TODO_ITEM
		do
			create l_item.make_with_scope ("test.e", 10, "Class-level TODO", 
											{EM_AI_TODO_ITEM}.Scope_class)
			assert ("item_created", l_item /= Void)
			assert ("class_scope", l_item.is_class_scope)
		end

	test_todo_item_to_string
			-- Test TODO item string representation
		note
			testing: "covers/{EM_AI_TODO_ITEM}.to_string"
		local
			l_item: EM_AI_TODO_ITEM
			l_str: STRING_32
		do
			create l_item.make ("my_class.e", 100, "Fix bug")
			l_str := l_item.to_string
			assert ("string_not_empty", not l_str.is_empty)
			assert ("contains_file", l_str.has_substring ("my_class.e"))
			assert ("contains_line", l_str.has_substring ("100"))
			assert ("contains_text", l_str.has_substring ("Fix bug"))
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
