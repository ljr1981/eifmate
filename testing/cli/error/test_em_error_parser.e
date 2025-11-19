note
	description: "[
		Unit tests for EM_ERROR_PARSER.
		Validates parsing logic against captured 'Golden Samples' and real integration.
	]"
	author: "EifMate"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_EM_ERROR_PARSER

inherit
	TEST_SET_BASE

	TESTING_CONSTANTS
		undefine
			default_create
		end

feature -- Test routines: Integration

	test_integrate_compiler_and_parser
			-- Run the compiler, get raw output, and manually feed it to the parser.
			-- Verifies every field of the resulting EM_ERROR object against known truth.
		note
			testing: "execution/serial"
		local
			l_ec: EM_COMPILER
			l_parser: EM_ERROR_PARSER
			l_errors: LIST [EM_ERROR]
			l_error: EM_ERROR
			l_project_path: STRING_32
			l_ecf_path: STRING_32
			l_response: EM_RESPONSE
		do
			-- 1. Setup paths
			l_project_path := "D:\prod\eifmate"
			l_ecf_path := l_project_path + "\eifmate.ecf"

			-- 2. Run Compiler (Expect Failure)
			create l_ec.make_with_path_and_target (ec_path, l_ecf_path, "eifmate_broken")
			l_ec.ec_melt_tuple (l_ec.project_configuration)

			-- 3. Create Parser
			create l_parser.make

			-- 4. Parse Output
			-- Note: In the fully integrated version, l_ec.compilation_errors would be populated automatically.
			-- Here we are testing the parser explicitly against the output.
			l_errors := l_parser.parse_errors (l_ec.last_output)

			-- 5. Assert List Structure
			assert_false ("errors_parsed", l_errors.is_empty)
			l_error := l_errors.first

			-- 6. Assert Core Error Data (Matches Debugger Screenshot)
			assert_strings_equal ("code_matches", "VEEN", l_error.code)
			assert_strings_equal ("category_matches", "Entities", l_error.category)
			assert_strings_equal ("message_matches", "unknown identifier.", l_error.message)

			-- 7. Assert Catalog Enrichment
			assert_true ("has_help_text", l_error.has_help_text)
			assert_string_contains ("help_text_content", l_error.help_text, "Entity name must be properly declared")

			-- 8. Assert Location Data (Using Check Attached Pattern)
			assert_true ("has_location", l_error.has_location)

			check has_location: attached l_error.location as al_loc then
				assert_strings_equal ("class_name_matches", "FAIL_APP", al_loc.class_name)
				assert_strings_equal ("feature_name_matches", "my_not_a_feature_fail", al_loc.feature_name)
				assert_int_equal ("line_number_matches", 31, al_loc.line_number)
			end

			create l_response.make_failure ("", l_errors)
			assert_string_contains ("json_out", l_response.to_json, expected_json)
		end

expected_json: STRING_32 = "[
{"success":false,"output":"","errors":[{"code":"VEEN","message":"unknown identifier.","severity":"Entities","suggestion":"Entity name must be properly declared. Check spelling, imports, and scope.","class":"FAIL_APP","feature":"my_not_a_feature_fail","line":31}],"warnings":[],"timestamp":
]"

feature -- Test routines: Parsing Logic

	test_parse_errors_golden_sample
			-- Parse the 'Golden Sample' text captured from FAIL_APP.
		note
			testing: "covers/{EM_ERROR_PARSER}.parse_errors"
		local
			l_parser: EM_ERROR_PARSER
			l_errors: LIST [EM_ERROR]
			l_error: EM_ERROR
			l_sample: STRING_32
		do
			-- 1. The Golden Sample
			l_sample := "[
Error code: VEEN

Error: unknown identifier.

Class: FAIL_APP
Feature: my_not_a_feature_fail
Identifier: not_a_feature
Line: 31
      do_nothing
->    not_a_feature
    end
]"

			-- 2. Parse
			create l_parser.make
			l_errors := l_parser.parse_errors (l_sample)

			-- 3. Assert Structure
			assert_int_equal ("error_count", 1, l_errors.count)
			l_error := l_errors.first

			-- 4. Assert Content
			assert_strings_equal ("code_extracted", "VEEN", l_error.code)

			-- 5. Assert Location
			check has_location: attached l_error.location as al_loc then
				assert_strings_equal ("class_name", "FAIL_APP", al_loc.class_name)
				assert_int_equal ("line_number", 31, al_loc.line_number)
			end
		end

feature {NONE} -- Implementation

	assert_int_equal (a_tag: STRING; a_expected, a_actual: INTEGER)
		do
			assert (a_tag + ": expected " + a_expected.out + " got " + a_actual.out, a_expected = a_actual)
		end

end
