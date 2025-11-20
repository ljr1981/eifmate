note
	description: "[
		Manifest for AI-TODO request package.
		
		Contains metadata about:
		- Request ID (for matching response)
		- Files included in package
		- TODO items to process
		- Timestamp
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_REQUEST_MANIFEST

create
	make

feature {NONE} -- Initialization

	make (a_request_id: READABLE_STRING_32)
			-- Initialize manifest with request ID
		require
			id_not_empty: not a_request_id.is_empty
		do
			create request_id.make_from_string (a_request_id)
			create files.make (5)
			create todo_items.make (10)
			timestamp := current_timestamp
		ensure
			request_id_set: request_id.same_string (a_request_id)
			files_empty: files.is_empty
			todos_empty: todo_items.is_empty
		end

feature -- Access

	request_id: STRING_32
			-- Unique identifier for this request

	files: ARRAYED_LIST [STRING_32]
			-- Paths to files in this package

	todo_items: ARRAYED_LIST [EM_AI_TODO_ITEM]
			-- AI-TODO items to process

	timestamp: STRING_32
			-- Request creation timestamp

feature -- Element change

	add_file (a_file_path: READABLE_STRING_32)
			-- Add file to manifest
		require
			path_not_empty: not a_file_path.is_empty
		do
			files.extend (create {STRING_32}.make_from_string (a_file_path))
		ensure
			file_added: files.count = old files.count + 1
		end

	add_todo_item (a_item: EM_AI_TODO_ITEM)
			-- Add TODO item to manifest
		require
			item_attached: a_item /= Void
		do
			todo_items.extend (a_item)
		ensure
			item_added: todo_items.count = old todo_items.count + 1
		end

feature -- Conversion

	to_markdown: STRING_32
			-- Convert manifest to markdown format for Obsidian
		do
			create Result.make (1024)

			Result.append ("# EifMate Request Manifest%N%N")
			Result.append ("**Request ID:** `")
			Result.append (request_id)
			Result.append ("`%N")
			Result.append ("**Timestamp:** ")
			Result.append (timestamp)
			Result.append ("%N%N")

			Result.append ("## Files in Package%N%N")
			across files as ic loop
				Result.append ("- `")
				Result.append (ic)
				Result.append ("`%N")
			end

			Result.append ("%N## AI-TODO Items%N%N")
			across todo_items as ic loop
				Result.append ("### ")
				Result.append (ic.file_path)
				Result.append (":")
				Result.append (ic.line_number.out)
				Result.append ("%N%N")
				Result.append ("**Scope:** ")
				Result.append (scope_name (ic.scope))
				Result.append ("%N%N")
				Result.append ("**TODO:**%N```%N")
				Result.append (ic.todo_text)
				Result.append ("%N```%N%N")
			end

			Result.append ("## Instructions for Claude%N%N")
			Result.append ("1. Review the AI-TODO items above%N")
			Result.append ("2. Implement the requested changes%N")
			Result.append ("3. Write results to `in-from-AI/")
			Result.append (request_id)
			Result.append ("/` folder%N")
			Result.append ("4. Include header comment: `-- RESPONSE_TO: ")
			Result.append (request_id)
			Result.append ("`%N")
		ensure
			result_not_empty: not Result.is_empty
		end

feature {NONE} -- Implementation

	current_timestamp: STRING_32
			-- Generate current timestamp
		local
			l_date_time: DATE_TIME
		do

			create l_date_time.make_now

			Result := l_date_time.out.to_string_32
		ensure
			result_not_empty: not Result.is_empty
		end

	scope_name (a_scope: INTEGER): STRING_32
			-- Get scope name
		do
			inspect a_scope
			when {EM_AI_TODO_ITEM}.Scope_line then
				Result := "Line"
			when {EM_AI_TODO_ITEM}.Scope_feature then
				Result := "Feature"
			when {EM_AI_TODO_ITEM}.Scope_class then
				Result := "Class"
			else
				Result := "Unknown"
			end
		ensure
			result_not_empty: not Result.is_empty
		end

invariant
	request_id_not_empty: not request_id.is_empty
	files_attached: files /= Void
	todos_attached: todo_items /= Void
	timestamp_not_empty: not timestamp.is_empty

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
