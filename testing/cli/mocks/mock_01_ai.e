-- RESPONSE_TO: req_2025112002141147

note
	description: "Mock class demonstrating name attribute with DbC."
	author: "Claude AI"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_01_AI

create
	make,
	make_with_name

feature {NONE} -- Initialization

	make
			-- Initialize with empty name
		do
			create name.make_empty
		ensure
			name_empty: name.is_empty
		end

	make_with_name (a_name: STRING_32)
			-- Initialize with specified name
		require
			name_not_void: a_name /= Void
			name_not_empty: not a_name.is_empty
			name_reasonable_length: a_name.count <= Max_name_length
		do
			create name.make_from_string (a_name)
		ensure
			name_set: name.same_string (a_name)
		end

feature -- Access

	name: STRING_32
			-- Name attribute

feature -- Element change

	set_name (a_name: STRING_32)
			-- Set name to specified value
		require
			name_not_void: a_name /= Void
			name_not_empty: not a_name.is_empty
			name_reasonable_length: a_name.count <= Max_name_length
		do
			create name.make_from_string (a_name)
		ensure
			name_set: name.same_string (a_name)
		end

feature -- Constants

	Max_name_length: INTEGER = 255
			-- Maximum reasonable length for name attribute
			-- Public because used in preconditions (client contract)

invariant
	name_attached: name /= Void
	name_reasonable_length: name.count <= Max_name_length

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
