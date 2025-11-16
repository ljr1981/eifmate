note
	description: "[
		Compilation error with location information.
		
		Represents a single error or warning from the compiler:
		- Error code (e.g., VEEN, VUAR)
		- Message text
		- File path
		- Line number
		- Column (if available)
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_ERROR

create
	make,
	make_with_location

feature {NONE} -- Initialization

	make (a_code: STRING; a_message: STRING)
			-- Create error with code and message
		require
			code_attached: a_code /= Void
			message_attached: a_message /= Void
		do
			code := a_code
			message := a_message
		ensure
			code_set: code = a_code
			message_set: message = a_message
		end

	make_with_location (a_code: STRING; a_message: STRING; a_file: STRING_32; a_line: INTEGER)
			-- Create error with location
		require
			code_attached: a_code /= Void
			message_attached: a_message /= Void
			file_attached: a_file /= Void
			line_positive: a_line > 0
		do
			make (a_code, a_message)
			file_path := a_file
			line := a_line
		ensure
			code_set: code = a_code
			message_set: message = a_message
			file_set: file_path = a_file
			line_set: line = a_line
		end

feature -- Access

	code: STRING
			-- Error code (e.g., "VEEN", "VUAR")

	message: STRING
			-- Error message text

	file_path: detachable STRING_32
			-- File where error occurred

	line: INTEGER
			-- Line number (0 if unknown)

	column: INTEGER
			-- Column number (0 if unknown)

feature -- Status report

	is_warning: BOOLEAN
			-- Is this a warning rather than error?

	has_location: BOOLEAN
			-- Does error have file location?
		do
			Result := attached file_path and then line > 0
		ensure
			definition: Result = (attached file_path and then line > 0)
		end

feature -- Element change

	set_warning
			-- Mark as warning
		do
			is_warning := True
		ensure
			is_warning: is_warning
		end

feature -- Conversion

	to_string: STRING
			-- Human-readable representation
		do
			create Result.make (100)
			Result.append (code)
			Result.append (": ")
			Result.append (message)
			if attached file_path as l_path then
				Result.append (" (")
				Result.append (l_path)
				if line > 0 then
					Result.append (":")
					Result.append (line.out)
				end
				Result.append (")")
			end
		ensure
			result_attached: Result /= Void
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
