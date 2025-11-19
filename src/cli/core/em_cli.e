note
	description: "[
		Main orchestrator for EifMate operations.
		Coordinates between request parser, compiler, error parser,
		and response builder to handle complete request/response cycle.
		
		Usage:
			create cli.make
			response := cli.process_request (request_json)
			print (response.to_json_string)
		
		Flow:
			1. Parse JSON request → EM_REQUEST
			2. Validate request
			3. Execute appropriate compiler operation → EM_COMPILER
			4. Parse compiler output → EM_ERROR_PARSER
			5. Build JSON response → EM_RESPONSE
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_CLI

inherit
	EM_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize CLI orchestrator
		do
			create compiler.make
			create error_parser.make
		ensure
			compiler_ready: compiler /= Void
			error_parser_ready: error_parser /= Void
		end

feature -- Access

	compiler: EM_COMPILER
			-- Compiler wrapper

	error_parser: EM_ERROR_PARSER
			-- Error output parser

	last_response: detachable EM_RESPONSE
			-- Last response generated

feature -- Operations


feature {NONE} -- Implementation

	execute_request (a_request: EM_REQUEST): EM_RESPONSE
			-- Execute the appropriate operation for request
		require
			request_valid: a_request.is_valid
		local
			l_project_path: PATH
		do
			create Result.make_success ("what?")

			-- Check compiler availability
--			if not compiler.is_available then
--				Result := create_error_response ("Eiffel compiler (ec.exe) not found - is ISE_EIFFEL set?")
--			else
--				l_project_path := a_request.ecf_path_as_path

--				-- Execute based on request type
--				if a_request.is_compile then
--					execute_compile (a_request, l_project_path, Result)

--				elseif a_request.is_compile_clean then
--					execute_compile_clean (a_request, l_project_path, Result)

--				elseif a_request.is_freeze then
--					execute_freeze (a_request, l_project_path, Result)

--				elseif a_request.is_finalize then
--					execute_finalize (a_request, l_project_path, Result)

--				elseif a_request.is_test then
--					execute_test (a_request, l_project_path, Result)

--				elseif a_request.is_query then
--					execute_query (a_request, l_project_path, Result)

--				else
--					Result := create_error_response ("Unknown request type: " + a_request.request_type)
--				end
--			end
		ensure
			result_attached: Result /= Void
		end

	execute_compile (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute standard compile
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
--			compiler.compile (a_path, a_request.target)
--			finalize_response (a_response)
		end

	execute_compile_clean (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute clean compile
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
--			compiler.compile_clean (a_path, a_request.target)
--			finalize_response (a_response)
		end

	execute_freeze (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute freeze
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
--			compiler.freeze (a_path, a_request.target)
--			finalize_response (a_response)
		end

	execute_finalize (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute finalize
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
--			compiler.finalize (a_path, a_request.target)
--			finalize_response (a_response)
		end

	execute_test (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute tests
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
--			compiler.run_tests (a_path, a_request.target)
--			finalize_response (a_response)
		end

	execute_query (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute code query
		require
			request_valid: a_request.is_valid
			request_is_query: a_request.is_query
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
			-- Dispatch to specific query type
--			if a_request.query_type.same_string (Query_type_flat) then
--				compiler.query_flat (a_path, a_request.target, a_request.class_name)

--			elseif a_request.query_type.same_string (Query_type_flatshort) then
--				compiler.query_flatshort (a_path, a_request.target, a_request.class_name)

--			elseif a_request.query_type.same_string (Query_type_clients) then
--				compiler.query_clients (a_path, a_request.target, a_request.class_name)

--			elseif a_request.query_type.same_string (Query_type_suppliers) then
--				compiler.query_suppliers (a_path, a_request.target, a_request.class_name)
--			end

			-- For queries, output is the answer (no error parsing needed)
--			a_response.set_output (compiler.last_output)
--			a_response.set_success (compiler.last_succeeded)
		end

--	finalize_response (a_response: EM_RESPONSE)
--			-- Parse compiler output and populate response
--		require
--			response_attached: a_response /= Void
--		do
--			-- Set raw output
--			a_response.set_output (compiler.last_output)

--			-- Set success flag
--			a_response.set_success (compiler.last_succeeded)

--			-- Parse errors if compilation failed
----			if not compiler.last_succeeded then
----				error_parser.parse (compiler.last_output)
------				a_response.add_errors (error_parser.errors)
------				a_response.add_errors (error_parser.warnings)
----			end
--		end

invariant
	compiler_attached: compiler /= Void
	error_parser_attached: error_parser /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
