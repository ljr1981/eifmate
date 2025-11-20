note
	description: "Tests for {EM_REQUEST_PACKAGER}."
	testing: "type/manual"

class
	TEST_EM_REQUEST_PACKAGER

inherit
	EQA_TEST_SET

feature -- Test routines

	test_packager_initialization
			-- Test packager creates properly
		note
			testing: "covers/{EM_REQUEST_PACKAGER}.make"
		local
			l_packager: EM_REQUEST_PACKAGER
		do
			create l_packager.make ("C:\project", "C:\vault")
			assert ("packager_created", l_packager /= Void)
			assert ("scanner_attached", l_packager.scanner /= Void)
			assert ("bridge_attached", l_packager.bridge /= Void)
		end

	test_response_processor_initialization
			-- Test response processor creates properly
		note
			testing: "covers/{EM_RESPONSE_PROCESSOR}.make"
		local
			l_processor: EM_RESPONSE_PROCESSOR
		do
			create l_processor.make ("C:\project", "C:\vault")
			assert ("processor_created", l_processor /= Void)
			assert ("project_path_set", 
					l_processor.project_path.same_string ("C:\project"))
			assert ("bridge_attached", l_processor.bridge /= Void)
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
