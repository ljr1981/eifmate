note
	description: "[
		Parser for EiffelStudio compiler error output.
		Enhanced version with ECMA-367 error code catalog integration.
		Provides helpful explanations for common validity errors.
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
			-- Initialize parser with catalog
		do
			make_catalog
		ensure
			catalog_initialized: codes /= Void
		end

feature -- Parsing

	parse_errors (a_output: STRING): ARRAYED_LIST [EM_ERROR]
			-- Parse compiler output and extract errors with enhanced information
		require
			output_attached: a_output /= Void
		local
			l_lines: LIST [STRING]
			l_error: detachable EM_ERROR
		do
			create Result.make (10)
			l_lines := a_output.split ('%N')
			
			across l_lines as ic loop
				l_error := parse_error_line (ic.item)
				if l_error /= Void then
					enhance_error_with_catalog (l_error)
					Result.extend (l_error)
				end
			end
		ensure
			result_attached: Result /= Void
		end

	parse_error_line (a_line: STRING): detachable EM_ERROR
			-- Parse single error line from compiler output
		require
			line_attached: a_line /= Void
		local
			l_code: STRING
			l_message: STRING
			l_location: detachable EM_ERROR_LOCATION
		do
			if is_error_line (a_line) then
				l_code := extract_error_code (a_line)
				l_message := extract_message (a_line)
				l_location := extract_location (a_line)
				
				create Result.make (l_code, l_message)
				if l_location /= Void then
					Result.set_location (l_location)
				end
			end
		end

feature {NONE} -- Implementation

	enhance_error_with_catalog (a_error: EM_ERROR)
			-- Add catalog information to error if available
		require
			error_attached: a_error /= Void
		local
			l_code_info: detachable EM_VALIDITY_CODE
		do
			l_code_info := code_info (a_error.code)
			if l_code_info /= Void then
				a_error.set_help_text (l_code_info.help_text)
				a_error.set_category (l_code_info.category.name)
			end
		end

	is_error_line (a_line: STRING): BOOLEAN
			-- Does line contain an error?
		require
			line_attached: a_line /= Void
		do
			Result := a_line.has_substring ("Error code:")
		end

	extract_error_code (a_line: STRING): STRING
			-- Extract error code from line
		require
			line_attached: a_line /= Void
			is_error: is_error_line (a_line)
		local
			l_start, l_end: INTEGER
		do
			l_start := a_line.substring_index ("Error code:", 1)
			if l_start > 0 then
				l_start := l_start + 11  -- Length of "Error code:"
				-- Skip whitespace
				from
				until
					l_start > a_line.count or else not a_line.item (l_start).is_space
				loop
					l_start := l_start + 1
				end
				
				-- Find end (next space or end of line)
				l_end := l_start
				from
				until
					l_end > a_line.count or else a_line.item (l_end).is_space
				loop
					l_end := l_end + 1
				end
				
				if l_end > l_start then
					Result := a_line.substring (l_start, l_end - 1)
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	extract_message (a_line: STRING): STRING
			-- Extract error message from line
		require
			line_attached: a_line /= Void
		do
			-- For now, return the whole line
			-- Can be enhanced to extract specific message part
			Result := a_line.twin
		ensure
			result_attached: Result /= Void
		end

	extract_location (a_line: STRING): detachable EM_ERROR_LOCATION
			-- Extract location information from line
		require
			line_attached: a_line /= Void
		do
			-- Placeholder - can be enhanced to extract:
			-- - Class name
			-- - Feature name  
			-- - Line number
			-- - File path
			-- For now, return Void
			Result := Void
		end

invariant
	catalog_initialized: codes /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
