note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_EM_PROJECT

inherit
	TEST_SET_BASE

feature -- Test routines

	test_project_data
			-- New test routine
		note
			testing:  "covers/{EM_PROJECT}"
		local
			l_project: EM_PROJECT
		do
			create l_project.make_from_path ("D:\prod\eifmate")
			assert_string_contains ("has_eifmate", l_project.path, "D:\prod\eifmate")

		end

end


