note
	description: "[
		Brings all EM_* classes into compilation system.
		
		This test class exists solely to ensure the compiler sees
		and compiles all EM_* classes even if they're not yet
		directly referenced by working code.
		
		Each EM_* class is represented by a detachable attribute,
		which is sufficient to bring it into the compilation universe.
	]"
	testing: "type/manual"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_EM_IN_SYSTEM

inherit
	TEST_SET_BASE

feature -- Test routines

	test_classes_in_system
			-- Verify all EM_* classes compile
		note
			testing: "execution/isolated"
		do
			-- This test passes simply by compiling successfully.
			-- The detachable attributes below bring all EM_* classes
			-- into the compilation system.
			assert ("all_em_classes_compile", True)
		end

feature {NONE} -- EM_* class references (bring into system)

	em_cli_app_ref: detachable EM_CLI_APP
			-- Reference to bring EM_CLI_APP into system

	em_request_ref: detachable EM_REQUEST
			-- Reference to bring EM_REQUEST into system

	em_response_ref: detachable EM_RESPONSE
			-- Reference to bring EM_RESPONSE into system

	em_compiler_ref: detachable EM_COMPILER
			-- Reference to bring EM_COMPILER into system

	em_project_ref: detachable EM_PROJECT
			-- Reference to bring EM_PROJECT into system

	em_error_ref: detachable EM_ERROR
			-- Reference to bring EM_ERROR into system

	em_constants_ref: detachable EM_CONSTANTS
			-- Reference to bring EM_CONSTANTS into system
		 attribute do_nothing end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
