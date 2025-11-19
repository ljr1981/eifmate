note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_EM_CLI

inherit
	TEST_SET_BASE

	TESTING_CONSTANTS
		undefine
			default_create
		end

feature -- Test routines

	test_cli
			-- New test routine
		note
			testing:  "covers/{EM_CLI}"
		local
			l_cli: EM_CLI
		do
			assert_false ("not_implemented", False)
		end

end


