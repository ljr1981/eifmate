note
	description: "[
		Categories for ECMA-367 validity error codes.
		Organizes codes by their primary domain.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_VALIDITY_CATEGORY

inherit
	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING)
			-- Initialize category with `a_name'
		require
			name_attached: a_name /= Void
			name_not_empty: not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name ~ a_name
		end

feature -- Access

	name: STRING
			-- Category name

feature -- Categories

	entities: EM_VALIDITY_CATEGORY
			-- Entities and expressions category
		once
			create Result.make ("Entities")
		ensure
			result_attached: Result /= Void
		end

	types: EM_VALIDITY_CATEGORY
			-- Type validity category
		once
			create Result.make ("Types")
		ensure
			result_attached: Result /= Void
		end

	usage: EM_VALIDITY_CATEGORY
			-- Usage and target validity category
		once
			create Result.make ("Usage")
		ensure
			result_attached: Result /= Void
		end

	members: EM_VALIDITY_CATEGORY
			-- Class members category
		once
			create Result.make ("Members")
		ensure
			result_attached: Result /= Void
		end

	redefinition: EM_VALIDITY_CATEGORY
			-- Inheritance and redefinition category
		once
			create Result.make ("Redefinition")
		ensure
			result_attached: Result /= Void
		end

	contracts: EM_VALIDITY_CATEGORY
			-- Design by Contract category
		once
			create Result.make ("Contracts")
		ensure
			result_attached: Result /= Void
		end

	generics: EM_VALIDITY_CATEGORY
			-- Generic parameters category
		once
			create Result.make ("Generics")
		ensure
			result_attached: Result /= Void
		end

	concurrency: EM_VALIDITY_CATEGORY
			-- SCOOP and concurrency category
		once
			create Result.make ("Concurrency")
		ensure
			result_attached: Result /= Void
		end

	other: EM_VALIDITY_CATEGORY
			-- Other validity issues category
		once
			create Result.make ("Other")
		ensure
			result_attached: Result /= Void
		end

feature -- Output

	out: STRING
			-- String representation
		do
			Result := name
		end

invariant
	name_attached: name /= Void
	name_not_empty: not name.is_empty

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
