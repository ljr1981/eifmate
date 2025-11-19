note
	description: "[
		Unit tests for the EM_COMPILER wrapper class.
		
		DEPENDENCY WARNING:
		These tests require a specific environment setup to pass:
		1. EiffelStudio 25.02 must be installed at the path defined in 'ec_path'.
		2. The 'simple_json' project must exist at 'D:\prod\simple_json\simple_json.ecf'.
		
		Test Strategy:
		- 'test_ec_help' validates basic executable connectivity.
		- 'test_ec_appinfo_*' validate stateless data retrieval.
		- 'test_ec_*melt' validate active compilation processes (Serial execution required).
		- 'test_make_*' validates the internal state configuration of the wrapper.
	]"
	author: "EifMate"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_EM_COMPILER

inherit
	TEST_SET_BASE

	TESTING_CONSTANTS
		undefine
			default_create
		end

feature -- Test routines: Connectivity & Basic Output

	test_ec_help
			-- Verify basic communication with ec.exe.
			-- SCENARIO:
			-- 1. Initialize without a path -> Expect failure (testing error handling).
			-- 2. Initialize with correct path -> Expect success and help text.
		note
			testing: "covers/{EM_COMPILER}.execute_ec", "covers/{EM_COMPILER}.last_errors"
			pathing: "[
$ISE_EIFFEL = C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard
$ISE_LIBRARY = C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard
$ISE_PLATFORM = win64
$ISE_C_COMPILER = msc_vc140
				]"
		local
			l_ec: EM_COMPILER
			l_help_output: STRING_32
		do
			-- 1. Negative Test: Default creation (no path) should fail to find ec.exe
			create l_ec.make
			l_ec.execute_ec (<<"-help">>)
			assert_false ("has_errors", l_ec.last_errors.is_empty)
			assert_strings_equal ("error_msg", "Failed to launch ec.exe", l_ec.last_errors [1])

			-- 2. Positive Test: Creation with valid path should succeed
			create l_ec.make_with_path (ec_path)
			l_ec.execute_ec (<<"-help">>)
			assert_true ("no_error", l_ec.last_errors.is_empty)

			-- Define expected help output (snapshot)
			l_help_output := "[
help: expected string to contain 'ISE EiffelStudio version 25.02.9.8732 - win64

Usage:
  C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\studio\spec\win64\bin\ec.exe
  -help | -version | -appinfo name |
  -full |	-batch | -clean | -verbose | -use_settings |
  -freeze | -finalize [-keep] | -precompile [-finalize [-keep]] | -c_compile |
  -loop | -debug | -quick_melt | -melt |
  (-clients | -suppliers | -ancestors | -descendants) [-filter filtername] class |
  (-flatshort | -flat | -short) [-filter filtername] [-all | -all_and_parents | class] |
  (-aversions | -dversions | -implementers) [-filter filtername] class feature |
  -callers [-filter filtername] [-show_all] [-assigners | -creators] class feature |
  -callees [-filter filtername] [-show_all] [-assignees | -creators] class feature |
  -filter filtername [-all | class] |
  -pretty input_filename [output_filename] |
  -reset_ide_layout |
  [[-config config.ecf] [-target target] [-config_option option] |
  [class_file.e [-library library_name]] |
  -stop | -no_library |
  -project_path project_directory | -file file |
  -preference preference_name preference_value |
  -ca_class (-all | class) | -ca_default | -ca_rule rule | -ca_setting file |
  -gc_stats]

Options:
  default (no option): quick melt the system.

  -ancestors: show the ancestors of a class.
  -appinfo: Output various application information (-appinfo ? to list available informations).
  -aversions: show the ancestor versions of a feature.
  -batch: launch the compilation without user request.
  -c_compile: launch C compilation if needed.
  -ca_class: analyze code of a class or of all non-library classes (-all).
  -ca_default: restore default code analyzer preferences.
  -ca_rule: activate code analyzer rule(s) (with settings).
  -ca_setting: load code analyzer preferences from a file.
  -callees: show the callees of a feature.
  -callers: show the callers of a feature.
  -class_file.e: specify a class file for single file compilation.
  -clean: delete existing project if any and perform a fresh compilation.
  -clients: show the clients of a class.
  -config: specify the configuration (ECF) file.
  -config_option: override configuration options of a target.
  -debug: debug the system as a command loop.
  -descendants: show the descendants of a class.
  -dversions: show the descendant versions of a feature.
  -file: save the output to a file.
  -filter: show a filtered form (troff, ...) of the class text.
  -finalize: finalize the system (discard assertions by default).
  -flat: show the flat form of a class.
  -flatshort: show the flat-short form of a class.
  -freeze: freeze the system.
  -full: with full class checking regardless of ECF settings.
  -gc_stats: Show GC statistics.
  -gui: start the graphical environment.
  -help: show this help message.
  -implementers: show the classes implementing a feature.
  -library: specify a library for single file compilation.
  -loop: run ec as a command loop.
  -melt: melt the system.
  -metadata_cache_path: Location of .NET MetadData consumer cache.
  -no_library: do not convert clusters into libraries.
  -overwrite_old_project: overwrite any existing old project.
  -precompile: precompile the system.
  -preference: override default or stored preference value.
  -pretty: show the pretty form of a class.
  -project: specify the project file to load (obsolete).
  -project_path: specify the compilation directory.
  -quick_melt: quick melt the system.
  -reset_ide_layout: reset the IDE layout.
  -short: show the short form of a class.
  -stop: stop on error.
  -suppliers: show the suppliers of a class.
  -target: specify the target.
  -use_settings: use settings for project location.
  -version: show compiler version number.

]"
			assert_string_contains ("help", l_help_output, l_ec.last_output)
		end

feature -- Test routines: AppInfo Commands

	test_ec_appinfo_environment
			-- Validate retrieval of environment variables (ISE_LIBRARY, etc.).
		note
			testing: "covers/{EM_COMPILER}.ec_environment"
		local
			l_ec: EM_COMPILER
		do
			create l_ec.make_with_path (ec_path)
			assert_string_contains ("appinfo", l_ec.ec_environment, ec_environment)
		end

	test_ec_appinfo_version
			-- Validate retrieval of compiler version string.
		note
			testing: "covers/{EM_COMPILER}.ec_version"
		local
			l_ec: EM_COMPILER
		do
			create l_ec.make_with_path (ec_path)
			assert_string_contains ("version", l_ec.ec_version, "25.02.9.8732")
		end

	test_ec_appinfo_layout
			-- Validate retrieval of IDE layout path.
		note
			testing: "covers/{EM_COMPILER}.ec_layout"
		local
			l_ec: EM_COMPILER
		do
			create l_ec.make_with_path (ec_path)
			assert_string_contains ("layout", l_ec.ec_layout, "C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard")
		end

feature -- Test routines: Active Compilation (Serial Execution)

	test_ec_melt
			-- Execute a full melt on 'simple_json'.
			-- Note: Validates 'ec_melt_tuple' specifically.
		note
			testing: "execution/serial", "covers/{EM_COMPILER}.ec_melt_tuple"
		local
			l_ec: EM_COMPILER
		do
			create l_ec.make_with_path (ec_path)
			l_ec.ec_melt_tuple (l_ec.config_target_path ("D:\prod\simple_json\simple_json.ecf"))
			assert_true ("no_errors", l_ec.last_errors.is_empty)
			assert_strings_equal_diff ("quick_melt", ec_quick_melt, l_ec.last_quick_melt)
		end

	test_ec_quick_melt
			-- Execute a quick melt on 'simple_json'.
			-- Note: Validates 'ec_quick_melt_tuple' specifically.
		note
			testing: "execution/serial", "covers/{EM_COMPILER}.ec_quick_melt_tuple"
		local
			l_ec: EM_COMPILER
		do
			create l_ec.make_with_path (ec_path)
			l_ec.ec_quick_melt_tuple (l_ec.config_target_path ("D:\prod\simple_json\simple_json.ecf"))
			assert_true ("no_errors", l_ec.last_errors.is_empty)
			assert_strings_equal_diff ("quick_melt", ec_melt, l_ec.last_quick_melt)
		end

	test_ec_flat
			-- Generate a Flat view of the 'SIMPLE_JSON' class.
			-- Verifies output contains specific source code markers.
		note
			testing: "covers/{EM_COMPILER}.ec_flat_tuple"
		local
			l_ec: EM_COMPILER
			l_tuple: TUPLE [config, target, project_path: STRING_32]
			l_tuple2: TUPLE [config, target, project_path, a_class: STRING_32]
		do
			create l_ec.make_with_path (ec_path)
			l_tuple := l_ec.config_target_path ("D:\prod\simple_json\simple_json.ecf")

			-- Construct arguments for flat view generation
			l_tuple2 := [l_tuple.config, l_tuple.target, l_tuple.project_path, {STRING_32} "SIMPLE_JSON"]

			l_ec.ec_flat_tuple (l_tuple2)

			assert_true ("no_errors", l_ec.last_errors.is_empty)
			assert_string_contains ("flat", l_ec.last_flat, ec_flat)
			-- Check for a specific comment known to exist in SIMPLE_JSON to verify content
			assert_string_contains ("array_value_comment", l_ec.last_flat, "-- JSON type name for array values")
		end

feature -- Test routines: Configuration State

	test_make_with_path_and_target
			-- Test the 'make_with_path_and_target' creation procedure.
			-- OBJECTIVE: Verify that the Target Name is successfully decoupled from
			-- the ECF Filename, which was a limitation of the previous heuristic.
		note
			testing: "execution/serial", "covers/{EM_COMPILER}.make_with_path_and_target"
		local
			l_ec: EM_COMPILER
			l_ecf: STRING_32
			l_target: STRING_32
			l_tuple: TUPLE [config, target, project_path: STRING_32]
			l_expected_dir: STRING_32
		do
			-- 1. Setup real-world data
			l_ecf := "D:\prod\simple_json\simple_json.ecf"

			-- This target name differs from the filename, requiring the new constructor.
			l_target := "simple_json_tests"

			-- We expect the logic to strip the filename "\simple_json.ecf" to get the dir
			l_expected_dir := "D:\prod\simple_json"

			-- 2. Create the compiler with the new constructor
			create l_ec.make_with_path_and_target (ec_path, l_ecf, l_target)

			-- 3. Assert State
			-- Verify the executable path was set correctly
			assert_string_starts_with ("path_set", l_ec.ec_executable_path, ec_path)

			-- Verify the config and target were stored exactly as passed
			assert_strings_equal_diff ("config_set", l_ecf, l_ec.project_config_path)
			assert_strings_equal_diff ("target_set", l_target, l_ec.project_target_name)

			-- 4. Test the 'project_configuration' logic (the directory stripper)
			l_tuple := l_ec.project_configuration

			assert_strings_equal_diff ("tuple_config_matches", l_ecf, l_tuple.config)
			assert_strings_equal_diff ("tuple_target_matches", l_target, l_tuple.target)

			-- Verify it derived the project directory correctly
			assert_strings_equal_diff ("tuple_path_derived_correctly", l_expected_dir, l_tuple.project_path)
		end

feature {NONE} -- Constants

	ec_environment: STRING_32 = "[
$ISE_EIFFEL = C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard
$ISE_LIBRARY = C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard
$ISE_PLATFORM = win64
$ISE_C_COMPILER = msc_vc140
]"
		-- Expected output snippet from '-appinfo environment'.

	ec_melt: STRING_32 = "[
Eiffel Compilation Manager
Version 25.02.9.8732 - win64

Degree 6: Examining System
System Recompiled.

]"
		-- Expected output format for a successful melt.

	ec_quick_melt: STRING_32 = "[
Eiffel Compilation Manager
Version 25.02.9.8732 - win64

Degree 6: Examining System
Degree 5: Parsing Classes
Degree 4: Analyzing Inheritance
Degree 3: Checking Types
Degree 2: Generating Byte Code
System Recompiled.

]"
		-- Expected output format for a successful quick_melt.

	ec_flat: STRING_32 = "SIMPLE_JSON"
		-- Expected class header in flat view.

end
