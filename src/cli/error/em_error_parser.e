note
	description: "[
		Parses raw EiffelStudio output into structured EM_ERROR objects.
		Uses a State Machine approach to handle multi-line error blocks.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_ERROR_PARSER

inherit
	EM_VALIDITY_CATALOG
		rename
			make as make_catalog
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize parser and load validity catalog.
		do
			make_catalog
		ensure
			catalog_initialized: codes /= Void
		end

feature -- Parsing

	parse_errors (a_output: STRING_32): ARRAYED_LIST [EM_ERROR]
			-- Parse full compiler output and return list of structured errors.
		require
			output_attached: a_output /= Void
		local
			l_lines: LIST [STRING_32]
			l_current_block: STRING_32
			l_in_error: BOOLEAN
			l_line: STRING_32
			i: INTEGER
		do
			create Result.make (5)
			l_lines := a_output.split ('%N')
			create l_current_block.make_empty
			l_in_error := False

			-- Use standard indexing loop to avoid cursor ambiguity
			from
				i := 1
			until
				i > l_lines.count
			loop
				l_line := l_lines [i]

				-- State Machine Transition: Start of new error
				if l_line.has_substring ("Error code:") then
					-- If we were already building an error, finish it
					if l_in_error then
						process_block (l_current_block, Result)
						create l_current_block.make_empty
					end
					l_in_error := True
				end

				-- State Action: Accumulate lines if inside an error block
				if l_in_error then
					l_current_block.append (l_line)
					l_current_block.append_character ('%N')
				end

				i := i + 1
			end

			-- Flush the final block
			if l_in_error and not l_current_block.is_empty then
				process_block (l_current_block, Result)
			end
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation

	process_block (a_block: STRING_32; a_result_list: LIST [EM_ERROR])
			-- Extract details from a multi-line error block and add to list.
		require
			block_not_empty: not a_block.is_empty
			result_list_attached: a_result_list /= Void
		local
			l_code: STRING_32
			l_message: STRING_32
			l_lines: LIST [STRING_32]
			l_error: EM_ERROR
			l_loc: detachable EM_ERROR_LOCATION
		do
			l_lines := a_block.split ('%N')

			-- 1. Extract Code
			l_code := extract_value (l_lines, "Error code:")

			-- 2. Extract Message (Usually follows "Error:")
			l_message := extract_value (l_lines, "Error:")
			if l_message.is_empty then
				l_message := "Compiler error " + l_code
			end

			-- 3. Create Error Object
			if not l_code.is_empty then
				create l_error.make (l_code, l_message)

				-- 4. Enhance with Catalog (Help Text)
				enhance_error_with_catalog (l_error)

				-- 5. Extract Location
				l_loc := extract_location_from_block (l_lines)
				if attached l_loc then
					l_error.set_location (l_loc)
				end

				a_result_list.extend (l_error)
			end
		end

	extract_value (a_lines: LIST [STRING_32]; a_key: STRING): STRING_32
			-- Find a line starting with `a_key` and return the value after it.
			-- Example: "Class: FAIL_APP" -> "FAIL_APP"
		local
			l_line: STRING_32
			l_split: LIST [STRING_32]
			i: INTEGER
		do
			create Result.make_empty
			from
				i := 1
			until
				i > a_lines.count
			loop
				l_line := a_lines [i].twin
				l_line.left_adjust

				if l_line.starts_with (a_key) then
					l_split := l_line.split (':')
					if l_split.count >= 2 then
						-- Handle cases like "Error code: VEEN" -> take second part
						Result := l_split [2]
						-- Re-attach subsequent parts if split inadvertently (e.g. timestamps)
						if l_split.count > 2 then
							from
								l_split.go_i_th (3)
							until
								l_split.after
							loop
								Result.append_character (':')
								Result.append (l_split.item)
								l_split.forth
							end
						end
						Result.left_adjust
						Result.right_adjust
					end
				end
				i := i + 1
			end
		end

	extract_location_from_block (a_lines: LIST [STRING_32]): detachable EM_ERROR_LOCATION
			-- specific scrapers for Class, Feature, Line
		local
			l_class, l_feature: STRING_32
			l_line_str: STRING_32
			l_line: INTEGER
		do
			l_class := extract_value (a_lines, "Class")
			l_feature := extract_value (a_lines, "Feature")
			l_line_str := extract_value (a_lines, "Line")

			if l_line_str.is_integer then
				l_line := l_line_str.to_integer
			else
				l_line := 0
			end

			if not l_class.is_empty then
				if not l_feature.is_empty then
					create Result.make (l_class, l_feature, l_line, "") -- File path often not in this block
				else
					create Result.make_simple (l_class, l_line)
				end
			end
		end

	enhance_error_with_catalog (a_error: EM_ERROR)
			-- Add catalog information to error if available
		require
			error_attached: a_error /= Void
		local
			l_code_info: detachable EM_VALIDITY_CODE
		do
			l_code_info := code_info (a_error.code)
			if l_code_info /= Void then
				a_error.set_help_text (l_code_info.description)
				a_error.set_category (l_code_info.category.name)
			end
		end

end
