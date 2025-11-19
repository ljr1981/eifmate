note
	description: "[
		Represents a single ECMA-367 validity error code with
		its help text and category.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_VALIDITY_CODE

create
	make

feature {NONE} -- Initialization

	make (a_code: STRING; a_description: STRING; a_category: EM_VALIDITY_CATEGORY)
			-- Initialize with `a_code', `a_description', and `a_category'
		require
			code_attached: a_code /= Void
			code_not_empty: not a_code.is_empty
			description_attached: a_description /= Void
			description_not_empty: not a_description.is_empty
			category_attached: a_category /= Void
		do
			code := a_code
			description := a_description
			category := a_category
		ensure
			code_set: code ~ a_code
			description_set: description ~ a_description
			category_set: category = a_category
		end

feature -- Access

	code: STRING
			-- Error code (e.g., "VEEN")

	description: STRING
			-- Human-readable description of what the error means

	category: EM_VALIDITY_CATEGORY
			-- Category this error belongs to

feature -- Output

	help_text: STRING
			-- Formatted help text for display
		do
			create Result.make (code.count + description.count + 50)
			Result.append ("Error ")
			Result.append (code)
			Result.append (" (")
			Result.append (category.name)
			Result.append ("):%N")
			Result.append (description)
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

invariant
	code_attached: code /= Void
	code_not_empty: not code.is_empty
	description_attached: description /= Void
	description_not_empty: not description.is_empty
	category_attached: category /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
