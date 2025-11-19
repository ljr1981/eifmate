note
	description: "Summary description for {TEST_SET_BASE_WITH_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_SET_BASE_WITH_CONSTANTS

inherit
	TEST_SET_BASE
		redefine
			on_prepare
		end

	TESTING_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Prepare

	on_prepare
			--<Precursor>
			-- Loads `configuration' chained with `do_nothing'
		do
			configuration.do_nothing
			Precursor
		end


end
