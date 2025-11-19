note
	description: "[
		Represents a single compiler error with optional location
		and enhanced help text from validity catalog.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_code: STRING; a_message: STRING)
			-- Initialize with error code and message
		require
			code_attached: a_code /= Void
			message_attached: a_message /= Void
		do
			code := a_code
			message := a_message
			create help_text.make_empty
			create category.make_empty
		ensure
			code_set: code ~ a_code
			message_set: message ~ a_message
		end

feature -- Access

	code: STRING
			-- Error code (e.g., "VEEN", "VUTA")

	message: STRING
			-- Compiler error message

	help_text: STRING
			-- Enhanced help text from catalog (if available)

	category: STRING
			-- Error category (if available)

	location: detachable EM_ERROR_LOCATION
			-- Optional location information

feature -- Status report

	has_help_text: BOOLEAN
			-- Does error have enhanced help text?
		do
			Result := not help_text.is_empty
		end

	has_category: BOOLEAN
			-- Does error have category information?
		do
			Result := not category.is_empty
		end

	has_location: BOOLEAN
			-- Does error have location information?
		do
			Result := location /= Void
		end

	is_error: BOOLEAN
			-- ??? TODO

	is_warning: BOOLEAN
			-- ??? TODO

feature -- Element change

	set_help_text (a_help_text: STRING)
			-- Set enhanced help text
		require
			help_text_attached: a_help_text /= Void
		do
			help_text := a_help_text
		ensure
			help_text_set: help_text ~ a_help_text
			has_help_text: has_help_text
		end

	set_category (a_category: STRING)
			-- Set error category
		require
			category_attached: a_category /= Void
		do
			category := a_category
		ensure
			category_set: category ~ a_category
			has_category: has_category
		end

	set_location (a_location: EM_ERROR_LOCATION)
			-- Set location information
		require
			location_attached: a_location /= Void
		do
			location := a_location
		ensure
			location_set: location = a_location
			has_location: has_location
		end

feature -- Output

	formatted_output: STRING
			-- Formatted error output with all available information
		do
			create Result.make (200)

			Result.append ("Error: ")
			Result.append (code)
			Result.append ("%N")

			if has_category then
				Result.append ("Category: ")
				Result.append (category)
				Result.append ("%N")
			end

			Result.append ("Message: ")
			Result.append (message)
			Result.append ("%N")

			if has_help_text then
				Result.append ("%NHelp:%N")
				Result.append (help_text)
				Result.append ("%N")
			end

			if has_location and then attached location as l_loc then
				Result.append ("%NLocation:%N")
				Result.append (l_loc.formatted_output)
			end
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

invariant
	code_attached: code /= Void
	message_attached: message /= Void
	help_text_attached: help_text /= Void
	category_attached: category /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
