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

	process_request (a_request_json: STRING_8): EM_RESPONSE
			-- Process JSON request and return JSON response
		require
			request_attached: a_request_json /= Void
			request_not_empty: not a_request_json.is_empty
		local
			l_request: EM_REQUEST
		do
			-- Parse request
			create l_request.make_from_json (a_request_json)
			
			if l_request.is_valid then
				-- Process valid request
				Result := execute_request (l_request)
			else
				-- Invalid request
				Result := create_error_response ("Invalid request: could not parse JSON")
			end
			
			last_response := Result
		ensure
			result_attached: Result /= Void
			last_response_set: last_response = Result
		end

	process_request_from_file (a_file_path: PATH): EM_RESPONSE
			-- Process request from JSON file
		require
			file_exists: (create {FILE_UTILITIES}).file_path_exists (a_file_path)
		local
			l_file: PLAIN_TEXT_FILE
			l_json: STRING_8
		do
			-- Read file
			create l_file.make_with_path (a_file_path)
			l_file.open_read
			l_file.read_stream (l_file.count)
			l_json := l_file.last_string
			l_file.close
			
			-- Process
			Result := process_request (l_json)
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation

	execute_request (a_request: EM_REQUEST): EM_RESPONSE
			-- Execute the appropriate operation for request
		require
			request_valid: a_request.is_valid
		local
			l_project_path: PATH
		do
			create Result.make
			
			-- Check compiler availability
			if not compiler.is_available then
				Result := create_error_response ("Eiffel compiler (ec.exe) not found - is ISE_EIFFEL set?")
			else
				l_project_path := a_request.ecf_path_as_path
				
				-- Execute based on request type
				if a_request.is_compile then
					execute_compile (a_request, l_project_path, Result)
					
				elseif a_request.is_compile_clean then
					execute_compile_clean (a_request, l_project_path, Result)
					
				elseif a_request.is_freeze then
					execute_freeze (a_request, l_project_path, Result)
					
				elseif a_request.is_finalize then
					execute_finalize (a_request, l_project_path, Result)
					
				elseif a_request.is_test then
					execute_test (a_request, l_project_path, Result)
					
				elseif a_request.is_query then
					execute_query (a_request, l_project_path, Result)
					
				else
					Result := create_error_response ("Unknown request type: " + a_request.request_type)
				end
			end
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
			compiler.compile (a_path, a_request.target)
			finalize_response (a_response)
		end

	execute_compile_clean (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute clean compile
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
			compiler.compile_clean (a_path, a_request.target)
			finalize_response (a_response)
		end

	execute_freeze (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute freeze
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
			compiler.freeze (a_path, a_request.target)
			finalize_response (a_response)
		end

	execute_finalize (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute finalize
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
			compiler.finalize (a_path, a_request.target)
			finalize_response (a_response)
		end

	execute_test (a_request: EM_REQUEST; a_path: PATH; a_response: EM_RESPONSE)
			-- Execute tests
		require
			request_valid: a_request.is_valid
			path_attached: a_path /= Void
			response_attached: a_response /= Void
		do
			compiler.run_tests (a_path, a_request.target)
			finalize_response (a_response)
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
			if a_request.query_type.same_string (Query_type_flat) then
				compiler.query_flat (a_path, a_request.target, a_request.class_name)
				
			elseif a_request.query_type.same_string (Query_type_flatshort) then
				compiler.query_flatshort (a_path, a_request.target, a_request.class_name)
				
			elseif a_request.query_type.same_string (Query_type_clients) then
				compiler.query_clients (a_path, a_request.target, a_request.class_name)
				
			elseif a_request.query_type.same_string (Query_type_suppliers) then
				compiler.query_suppliers (a_path, a_request.target, a_request.class_name)
			end
			
			-- For queries, output is the answer (no error parsing needed)
			a_response.set_output (compiler.last_output)
			a_response.set_success (compiler.last_succeeded)
		end

	finalize_response (a_response: EM_RESPONSE)
			-- Parse compiler output and populate response
		require
			response_attached: a_response /= Void
		do
			-- Set raw output
			a_response.set_output (compiler.last_output)
			
			-- Set success flag
			a_response.set_success (compiler.last_succeeded)
			
			-- Parse errors if compilation failed
			if not compiler.last_succeeded then
				error_parser.parse (compiler.last_output)
				a_response.add_errors (error_parser.errors)
				a_response.add_errors (error_parser.warnings)
			end
		end

	create_error_response (a_message: STRING_8): EM_RESPONSE
			-- Create response for error condition
		require
			message_attached: a_message /= Void
		local
			l_error: EM_ERROR
		do
			create Result.make
			Result.set_success (False)
			Result.set_output (a_message)
			
			create l_error.make ("EIFMATE_ERROR", a_message, Error_severity_error)
			Result.add_error (l_error)
		ensure
			result_attached: Result /= Void
			result_failed: not Result.success
		end

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
