note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TEST_SET

inherit
	TEST_SET_BASE

feature -- Test routines

	test_test
			-- New test routine
		do
			assert_false ("not_implemented", False)
		end

end


