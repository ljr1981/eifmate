note
	description: "[
		Main orchestrator for EifMate operations.
		Coordinates between request parser, compiler, error parser,
		and response builder to handle complete request/response cycle.
	]"
	author: "EifMate"
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
			create error_parser.make
		ensure
			error_parser_ready: error_parser /= Void
		end

feature -- Access

	error_parser: EM_ERROR_PARSER
			-- Error output parser

feature -- Operations

	process_request (a_json_content: STRING): EM_RESPONSE
			-- Process a raw JSON request string and return a structured response.
		require
			json_attached: a_json_content /= Void
		local
			l_request: EM_REQUEST
		do
			-- 1. Parse Request
			create l_request.make_from_json (a_json_content)

			if not l_request.is_valid then
				-- Fix VUAR(2): Pass empty list instead of Void
				create Result.make_failure ("Invalid JSON request format.", empty_errors)
			else
				-- 2. Dispatch based on request type
				if l_request.is_compile then
					Result := handle_compile (l_request)
				elseif l_request.is_query then
					Result := handle_query (l_request)
				else
					-- Fix VUAR(2): Pass empty list instead of Void
					create Result.make_failure ("Unknown request type: " + l_request.request_type, empty_errors)
				end
			end
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation: Compilation

	handle_compile (a_request: EM_REQUEST): EM_RESPONSE
			-- Execute compilation logic.
		require
			request_valid: a_request.is_valid
			is_compile: a_request.is_compile
		local
			l_errors: LIST [EM_ERROR]
			l_compiler: EM_COMPILER
		do
			-- Fix VUEX(2) & VUTA(2): Create fresh instance using helper for path
			create l_compiler.make_with_path_and_target (default_ec_path, a_request.ecf_path, a_request.target)

			-- Execute Melt (Default to melt for compile requests)
			-- [cite_start]-- Usage pattern from TEST_EM_COMPILER [cite: 41, 45]
			l_compiler.ec_melt_tuple (l_compiler.project_configuration)

			-- Parse Output for Errors
			-- [cite_start]-- Usage pattern from TEST_EM_ERROR_PARSER [cite: 7]
			l_errors := error_parser.parse_errors (l_compiler.last_output)

			-- Build Response
			if l_compiler.last_errors.is_empty and l_errors.is_empty then
				create Result.make_success (l_compiler.last_output)
			else
				create Result.make_failure (l_compiler.last_output, l_errors)
			end
		end

feature {NONE} -- Implementation: Queries

	handle_query (a_request: EM_REQUEST): EM_RESPONSE
			-- Execute query logic (flat, flatshort, etc).
		require
			request_valid: a_request.is_valid
			is_query: a_request.is_query
		local
			l_config_tuple: TUPLE [config, target, project_path: STRING_32]
			l_query_tuple: TUPLE [config, target, project_path, a_class: STRING_32]
			l_compiler: EM_COMPILER
		do
			-- Fix VUEX(2) & VUTA(2): Create fresh instance using helper for path
			create l_compiler.make_with_path_and_target (default_ec_path, a_request.ecf_path, a_request.target)
			l_config_tuple := l_compiler.project_configuration

			-- Construct arguments for flat/flatshort view generation
			-- Fix VJAR: Convert class_name to STRING_32 to match TUPLE signature
			l_query_tuple := [l_config_tuple.config, l_config_tuple.target, l_config_tuple.project_path, a_request.class_name.to_string_32]

			if a_request.query_type.is_case_insensitive_equal ("flat") then
				-- [cite_start]-- Usage pattern from TEST_EM_COMPILER [cite: 47]
				l_compiler.ec_flat_tuple (l_query_tuple)

				if l_compiler.last_errors.is_empty then
					create Result.make_success (l_compiler.last_flat)
				else
					-- Fix VUAR(2): Provide empty list if we only have a string error from the compiler wrapper
					create Result.make_failure (l_compiler.last_errors.first, empty_errors)
				end

			elseif a_request.query_type.is_case_insensitive_equal ("flatshort") then
				-- Assuming ec_flatshort_tuple exists matching the pattern
				l_compiler.ec_flatshort_tuple (l_query_tuple)

				if l_compiler.last_errors.is_empty then
					create Result.make_success (l_compiler.last_flat)
				else
					create Result.make_failure (l_compiler.last_errors.first, empty_errors)
				end
			else
				create Result.make_failure ("Unsupported query type: " + a_request.query_type, empty_errors)
			end
		end

feature {NONE} -- Implementation: Helpers

	empty_errors: ARRAYED_LIST [EM_ERROR]
			-- Helper to return an empty list for void safety compliance.
		do
			create Result.make (0)
		end

	default_ec_path: STRING_32
			-- Retrieve default compiler path from a temporary instance.
			-- Solves VUTA(2) by avoiding self-reference during creation.
		local
			l_temp: EM_COMPILER
		do
			create l_temp.make
			Result := l_temp.ec_executable_path
		end

invariant
	error_parser_attached: error_parser /= Void

end
