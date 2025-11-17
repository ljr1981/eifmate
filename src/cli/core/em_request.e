note
	description: "[
		JSON request parser for EifMate.
		Parses incoming JSON requests from Claude and extracts:
		- Request type (compile, test, query, etc.)
		- ECF file path
		- Target name
		- Additional parameters based on type
		
		Request format:
		{
			\"type\": \"compile\",
			\"ecf_path\": \"D:/projects/myapp/myapp.ecf\",
			\"target\": \"my_target\"
		}
		
		Query request format:
		{
			\"type\": \"query\",
			\"query_type\": \"flatshort\",
			\"ecf_path\": \"D:/projects/myapp/myapp.ecf\",
			\"target\": \"my_target\",
			\"class_name\": \"MY_CLASS\"
		}
		
		Usage:
			create request.make_from_json (json_string)
			if request.is_valid then
				if request.is_compile then
					compiler.compile (request.ecf_path, request.target)
				end
			end
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_REQUEST

inherit
	EM_CONSTANTS

create
	make_from_json,
	make_from_string

feature {NONE} -- Initialization

	make_from_json (a_json: STRING_8)
			-- Parse JSON request string
		require
			json_attached: a_json /= Void
			json_not_empty: not a_json.is_empty
		local
			l_parser: SIMPLE_JSON
			l_value: detachable SIMPLE_JSON_VALUE
			l_obj: SIMPLE_JSON_OBJECT
		do
			-- Default initialization
			create request_type.make_empty
			create ecf_path.make_empty
			create target.make_empty
			create class_name.make_empty
			create query_type.make_empty
			is_valid := False

			-- Parse JSON
			create l_parser
			l_value := l_parser.parse (a_json)

			if attached l_value and then l_value.is_object then
				l_obj := l_value.as_object

				-- Extract request type (required)
				if attached l_obj.item (Json_key_request_type) as l_type_val then
					if l_type_val.is_string then
						request_type := l_type_val.as_string_32.to_string_8
					end
				end

				-- Extract ECF path (required)
				if attached l_obj.item (Json_key_ecf_path) as l_ecf_val then
					if l_ecf_val.is_string then
						ecf_path := l_ecf_val.as_string_32.to_string_8
					end
				end

				-- Extract target (required)
				if attached l_obj.item (Json_key_target) as l_target_val then
					if l_target_val.is_string then
						target := l_target_val.as_string_32.to_string_8
					end
				end

				-- Extract class name (optional - for queries)
				if attached l_obj.item (Json_key_class_name) as l_class_val then
					if l_class_val.is_string then
						class_name := l_class_val.as_string_32.to_string_8
					end
				end

				-- Extract query type (optional - for query requests)
				if attached l_obj.item (Json_key_query_type) as l_query_val then
					if l_query_val.is_string then
						query_type := l_query_val.as_string_32.to_string_8
					end
				end

				-- Validate required fields
				is_valid := not request_type.is_empty and
				            not ecf_path.is_empty and
				            not target.is_empty
			end
		end

	make_from_string (a_type, a_ecf, a_target: STRING_8)
			-- Create request directly from components
		require
			type_attached: a_type /= Void
			type_not_empty: not a_type.is_empty
			ecf_attached: a_ecf /= Void
			ecf_not_empty: not a_ecf.is_empty
			target_attached: a_target /= Void
			target_not_empty: not a_target.is_empty
		do
			request_type := a_type.twin
			ecf_path := a_ecf.twin
			target := a_target.twin
			create class_name.make_empty
			create query_type.make_empty
			is_valid := True
		ensure
			valid: is_valid
			type_set: request_type.same_string (a_type)
		end

feature -- Access

	request_type: STRING_8
			-- Type of request (compile, test, query, etc.)

	ecf_path: STRING_8
			-- Path to ECF configuration file

	target: STRING_8
			-- Target name within ECF

	class_name: STRING_8
			-- Class name (for query requests)

	query_type: STRING_8
			-- Query type (flat, flatshort, etc.)

feature -- Status report

	is_valid: BOOLEAN
			-- Was request successfully parsed?

	is_compile: BOOLEAN
			-- Is this a compile request?
		do
			Result := request_type.same_string (Request_type_compile)
		end

	is_compile_clean: BOOLEAN
			-- Is this a clean compile request?
		do
			Result := request_type.same_string (Request_type_compile_clean)
		end

	is_freeze: BOOLEAN
			-- Is this a freeze request?
		do
			Result := request_type.same_string (Request_type_freeze)
		end

	is_finalize: BOOLEAN
			-- Is this a finalize request?
		do
			Result := request_type.same_string (Request_type_finalize)
		end

	is_test: BOOLEAN
			-- Is this a test request?
		do
			Result := request_type.same_string (Request_type_test)
		end

	is_query: BOOLEAN
			-- Is this a query request?
		do
			Result := request_type.same_string (Request_type_query)
		end

feature -- Element change

	set_class_name (a_name: STRING_8)
			-- Set class name for query
		require
			name_attached: a_name /= Void
		do
			class_name := a_name.twin
		ensure
			class_name_set: class_name.same_string (a_name)
		end

	set_query_type (a_type: STRING_8)
			-- Set query type
		require
			type_attached: a_type /= Void
		do
			query_type := a_type.twin
		ensure
			query_type_set: query_type.same_string (a_type)
		end

feature -- Conversion

	ecf_path_as_path: PATH
			-- Convert ECF path string to PATH object
		require
			valid: is_valid
		do
			create Result.make_from_string (ecf_path)
		ensure
			result_attached: Result /= Void
		end

invariant
	request_type_attached: request_type /= Void
	ecf_path_attached: ecf_path /= Void
	target_attached: target /= Void
	class_name_attached: class_name /= Void
	query_type_attached: query_type /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
