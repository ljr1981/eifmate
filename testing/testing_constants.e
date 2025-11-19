note
	description: "Configuration constants loaded dynamically from `testing\config_project.json'."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TESTING_CONSTANTS

feature -- Access

	ec_path: STRING_32
			-- Path to the compiler executable (ec.exe).
		once
			Result := config_string ("ec_path")
		end

	test_project_root: STRING_32
			-- Root directory of the main project under test.
		once
			Result := config_string ("test_project_root")
		end

	test_external_lib_root: STRING_32
			-- Root directory of the external library dependencies.
		once
			Result := config_string ("test_external_lib_root")
		end

	test_external_target: STRING_32
			-- Target name for the external library.
		once
			Result := config_string ("test_external_target")
		end

feature {NONE} -- Implementation

	Config_filename: STRING_32
			-- Testing config data
		local
			l_env: EXECUTION_ENVIRONMENT
		once
			create l_env
			Result := l_env.current_working_path.absolute_path.out + "\testing\config_testing.json"
		end

	configuration: SIMPLE_JSON_OBJECT
			-- Singleton access to the parsed configuration object.
		local
			l_parser: SIMPLE_JSON
		once
			create l_parser
			-- parse_file uses PLAIN_TEXT_FILE internally to read the content
			if attached l_parser.parse_file (Config_filename) as l_value and then l_value.is_object then
				Result := l_value.as_object
			else
				-- Fallback to empty object if file is missing or invalid
				create Result.make
			end
		ensure
			result_not_void: Result /= Void
		end

	config_string (a_key: STRING_32): STRING_32
			-- Helper to safely retrieve a string value from the configuration.
		require
			key_not_empty: not a_key.is_empty
		do
			if attached configuration.string_item (a_key) as l_string then
				Result := l_string
			else
				create Result.make_empty
			end
		ensure
			result_not_void: Result /= Void
		end

end
