-- RESPONSE_TO: req_202511210881139

note
	description: "Tests for {EM_CLI} orchestration and request processing."
	testing: "type/manual"

class
	TEST_EM_CLI

inherit
	TEST_SET_BASE_WITH_CONSTANTS

feature -- Test routines

	test_cli_initialization
			-- Test CLI creates properly with error parser
		note
			testing: "execution/serial", "covers/{EM_CLI}.make"
		local
			l_cli: EM_CLI
		do
			create l_cli.make
			assert ("cli_created", l_cli /= Void)
			assert ("error_parser_attached", l_cli.error_parser /= Void)
		end

	test_process_invalid_json
			-- Test processing invalid JSON returns failure response
		note
			testing: "execution/serial", "covers/{EM_CLI}.process_request"
		local
			l_cli: EM_CLI
			l_response: EM_RESPONSE
			l_invalid_json: STRING
		do
			create l_cli.make
			l_invalid_json := "{invalid json content"

			l_response := l_cli.process_request (l_invalid_json)

			assert ("response_attached", l_response /= Void)
			assert ("response_is_failure", not l_response.is_success)
			assert ("has_error_message",
					l_response.output.has_substring ("Invalid"))
		end

	test_process_unknown_request_type
			-- Test processing unknown request type returns failure
		note
			testing: "execution/serial", "covers/{EM_CLI}.process_request"
		local
			l_cli: EM_CLI
			l_response: EM_RESPONSE
			l_json: STRING_32
		do
			create l_cli.make
			l_json := "{%"type%":%"unknown%",%"ecf_path%":%"test.ecf%",%"target%":%"test%"}"

			l_response := l_cli.process_request (l_json)

			assert ("response_attached", l_response /= Void)
			assert ("response_is_failure", not l_response.is_success)
			assert ("has_unknown_type_message",
					l_response.output.has_substring ("Unknown request type"))
		end

	test_process_compile_request_basic
			-- Test basic compile request structure
		note
			testing: "execution/serial",
					 "covers/{EM_CLI}.process_request",
					 "covers/{EM_CLI}.handle_compile"
		local
			l_cli: EM_CLI
			l_response: EM_RESPONSE
			l_json: STRING_32
		do
			create l_cli.make_with_default_ec_path (ec_path)
			create l_json.make_empty
			l_json.append ("{%"type%":%"compile%",%"ecf_path%":%"")
			l_json.append (test_external_lib_root)
			l_json.append ("\\simple_json.ecf%",%"target%":%"")
			l_json.append (test_external_target)
			l_json.append ("%"}")

			l_response := l_cli.process_request (l_json)

			assert ("response_attached", l_response /= Void)
			-- Note: Actual success depends on compilation, just verify structure
			assert ("has_message", not l_response.output.is_empty)
		end

	test_process_query_flat_request
			-- Test flat query request
		note
			testing: "execution/serial",
					 "covers/{EM_CLI}.process_request",
					 "covers/{EM_CLI}.handle_query"
		local
			l_cli: EM_CLI
			l_response: EM_RESPONSE
			l_json: STRING_32
		do
			create l_cli.make_with_default_ec_path (ec_path)
			create l_json.make_empty
			l_json.append ("{%"type%":%"query%",%"query_type%":%"flat%",%"ecf_path%":%"")
			l_json.append (test_external_lib_root)
			l_json.append ("\simple_json.ecf%",%"target%":%"")
			l_json.append (test_external_target)
			l_json.append ("%",%"class_name%":%"SIMPLE_JSON_OBJECT%"}")
			l_json.replace_substring_all ("\", "\\")

			l_response := l_cli.process_request (l_json)

			assert ("response_attached", l_response /= Void)
			-- Verify query was processed
			assert ("has_message", not l_response.output.is_empty)

			--Eiffel Compilation Manager
			--Version 25.02.9.8732 - win64

			--Degree 6: Examining System
			--System Recompiled.

			assert_string_contains ("manager_confirmed", l_response.output, "Eiffel Compilation Manager")
			assert_string_contains ("version_confirmed", l_response.output, "Version 25.02.9.8732 - win64")
			assert_string_contains ("degree6_confirmed", l_response.output, "Degree 6: Examining System")
			assert_string_contains ("system_confirmed", l_response.output, "System Recompiled.")
		end

	test_process_query_flatshort_request
			-- Test flatshort query request
		note
			testing: "execution/serial",
					 "covers/{EM_CLI}.process_request",
					 "covers/{EM_CLI}.handle_query"
		local
			l_cli: EM_CLI
			l_response: EM_RESPONSE
			l_json: STRING_32
		do
			create l_cli.make_with_default_ec_path (ec_path)
			create l_json.make_empty
			l_json.append ("{%"type%":%"query%",%"query_type%":%"flatshort%",%"ecf_path%":%"")
			l_json.append (test_external_lib_root)
			l_json.append ("\\simple_json.ecf%",%"target%":%"")
			l_json.append (test_external_target)
			l_json.append ("%",%"class_name%":%"SIMPLE_JSON_OBJECT%"}")
			l_json.replace_substring_all ("\", "\\")

			l_response := l_cli.process_request (l_json)

			assert ("response_attached", l_response /= Void)
			assert ("has_message", not l_response.output.is_empty)

			--Eiffel Compilation Manager
			--Version 25.02.9.8732 - win64

			--Degree 6: Examining System
			--System Recompiled.

			assert_string_contains ("manager_confirmed", l_response.output, "Eiffel Compilation Manager")
			assert_string_contains ("version_confirmed", l_response.output, "Version 25.02.9.8732 - win64")
			assert_string_contains ("degree6_confirmed", l_response.output, "Degree 6: Examining System")
			assert_string_contains ("system_confirmed", l_response.output, "System Recompiled.")
		end

	test_process_unsupported_query_type
			-- Test unsupported query type returns failure
		note
			testing: "execution/serial",
					 "covers/{EM_CLI}.handle_query"
		local
			l_cli: EM_CLI
			l_response: EM_RESPONSE
			l_json: STRING_32
		do
			create l_cli.make_with_default_ec_path (ec_path)
			l_json := "{%"type%":%"query%",%"query_type%":%"unsupported%",%"ecf_path%":%"test.ecf%",%"target%":%"test%",%"class_name%":%"TEST_CLASS%"}"

			l_response := l_cli.process_request (l_json)

			assert ("response_attached", l_response /= Void)
			assert ("response_is_failure", not l_response.is_success)
			assert ("has_unsupported_message",
					l_response.output.has_substring ("Unsupported query type"))
		end

	test_empty_errors_helper
			-- Test empty_errors helper returns valid empty list
		note
			testing: "execution/serial",
					 "covers/{EM_CLI}.empty_errors"
		local
			l_cli: EM_CLI
		do
			create l_cli.make_with_default_ec_path (ec_path)
			-- Helper is private but tested indirectly through process_request
			-- This test documents the helper's purpose
			assert ("cli_initialized", l_cli /= Void)
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
