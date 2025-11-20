note
	description: "[
		Represents a single AI-TODO item found in Eiffel source code.
		
		Captures:
		- File location
		- Line number
		- TODO text
		- Scope (class-wide, feature-wide, line-specific)
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_AI_TODO_ITEM

create
	make,
	make_with_scope

feature {NONE} -- Initialization

	make (a_file_path: READABLE_STRING_32; a_line_number: INTEGER; a_text: READABLE_STRING_32)
			-- Initialize TODO item with basic information
		require
			file_path_not_empty: not a_file_path.is_empty
			line_number_positive: a_line_number > 0
			text_not_empty: not a_text.is_empty
		do
			create file_path.make_from_string (a_file_path)
			line_number := a_line_number
			create todo_text.make_from_string (a_text)
			scope := Scope_line
		ensure
			file_path_set: file_path.same_string (a_file_path)
			line_number_set: line_number = a_line_number
			text_set: todo_text.same_string (a_text)
			default_scope: scope = Scope_line
		end

	make_with_scope (a_file_path: READABLE_STRING_32; a_line_number: INTEGER; 
					 a_text: READABLE_STRING_32; a_scope: INTEGER)
			-- Initialize TODO item with explicit scope
		require
			file_path_not_empty: not a_file_path.is_empty
			line_number_positive: a_line_number > 0
			text_not_empty: not a_text.is_empty
			valid_scope: a_scope >= Scope_line and a_scope <= Scope_class
		do
			make (a_file_path, a_line_number, a_text)
			scope := a_scope
		ensure
			scope_set: scope = a_scope
		end

feature -- Access

	file_path: STRING_32
			-- Path to file containing this TODO

	line_number: INTEGER
			-- Line number where TODO appears

	todo_text: STRING_32
			-- Text of the TODO item

	scope: INTEGER
			-- Scope of the TODO (line, feature, or class)

feature -- Status report

	is_line_scope: BOOLEAN
			-- Is this a line-specific TODO?
		do
			Result := scope = Scope_line
		end

	is_feature_scope: BOOLEAN
			-- Is this a feature-wide TODO?
		do
			Result := scope = Scope_feature
		end

	is_class_scope: BOOLEAN
			-- Is this a class-wide TODO?
		do
			Result := scope = Scope_class
		end

feature -- Conversion

	to_string: STRING_32
			-- Human-readable representation
		do
			create Result.make (256)
			Result.append (file_path)
			Result.append_character (':')
			Result.append (line_number.out)
			Result.append (" [")
			Result.append (scope_name)
			Result.append ("] ")
			Result.append (todo_text)
		ensure
			result_not_empty: not Result.is_empty
		end

feature {NONE} -- Implementation

	scope_name: STRING_32
			-- Name of current scope
		do
			inspect scope
			when Scope_line then
				Result := "line"
			when Scope_feature then
				Result := "feature"
			when Scope_class then
				Result := "class"
			else
				Result := "unknown"
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Constants

	Scope_line: INTEGER = 1
			-- Line-specific TODO

	Scope_feature: INTEGER = 2
			-- Feature-wide TODO

	Scope_class: INTEGER = 3
			-- Class-wide TODO

invariant
	file_path_not_empty: not file_path.is_empty
	line_number_positive: line_number > 0
	text_not_empty: not todo_text.is_empty
	valid_scope: scope >= Scope_line and scope <= Scope_class

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
