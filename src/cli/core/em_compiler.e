note
	description: "Eiffel compiler wrapper for executing ec.exe (EiffelStudio Compiler)."
	author: "EifMate"
	date: "$Date$"
	revision: "$Revision$"
	model: ec_executable_path, last_output, last_errors, last_exit_code, project_config_path, project_target_name

class
	EM_COMPILER

create
	make,
	make_with_path,
	make_with_path_and_target

feature {NONE} -- Initialization

	make
			-- Initialize compiler wrapper with default system path.
		do
			create last_output.make_empty
			create last_errors.make (0)
			last_exit_code := -1
			ec_executable_path := "ec.exe"

			-- Initialize project state to empty (Unconfigured state)
			create project_config_path.make_empty
			create project_target_name.make_empty
		ensure
			output_initialized: last_output /= Void and then last_output.is_empty
			errors_initialized: last_errors /= Void and then last_errors.is_empty
			default_path_set: ec_executable_path.is_equal ("ec.exe")
			exit_code_reset: last_exit_code = -1
			no_project_set: project_config_path.is_empty and project_target_name.is_empty
		end

	make_with_path (a_path: READABLE_STRING_GENERAL)
			-- Initialize with specific directory path to executable.
		require
			path_exists: a_path /= Void and then not a_path.is_empty
		do
			make
			create ec_executable_path.make_from_string_general (a_path)
			if not ec_executable_path.ends_with ("\") then
				ec_executable_path.append_character ('\')
			end
			ec_executable_path.append ("ec.exe")
		ensure
			output_initialized: last_output /= Void
			errors_initialized: last_errors /= Void
			path_set: ec_executable_path /= Void
			path_contains_exe: ec_executable_path.ends_with ("ec.exe")
			path_starts_with_arg: ec_executable_path.starts_with (a_path)
			no_project_set: project_config_path.is_empty and project_target_name.is_empty
		end

	make_with_path_and_target (a_ec_path, a_ecf_file, a_target: READABLE_STRING_GENERAL)
			-- Initialize with specific EC path and lock in a specific Project and Target.
		require
			ec_path_valid: a_ec_path /= Void and then not a_ec_path.is_empty
			ecf_valid: a_ecf_file /= Void and then not a_ecf_file.is_empty
			target_valid: a_target /= Void and then not a_target.is_empty
			is_ecf: a_ecf_file.ends_with (".ecf")
		do
			make_with_path (a_ec_path)
			create project_config_path.make_from_string_general (a_ecf_file)
			create project_target_name.make_from_string_general (a_target)
		ensure
			path_set: ec_executable_path.starts_with (a_ec_path)
			project_set: project_config_path.same_string (a_ecf_file)
			target_set: project_target_name.same_string (a_target)
		end

feature -- Access

	ec_executable_path: STRING_32
			-- Path to ec.exe executable.

	project_config_path: STRING_32
			-- Path to the .ecf file for the current project context.
			-- (Empty if not configured).

	project_target_name: STRING_32
			-- Name of the build target for the current project context.
			-- (Empty if not configured).

	last_output: STRING_32
			-- Captured output from last execution.

	last_errors: ARRAYED_LIST [STRING_32]
			-- Parsed error messages.

	last_exit_code: INTEGER
			-- Exit code from last execution.

	project_configuration: TUPLE [config, target, project_path: STRING_32]
			-- Return the configured project details as a tuple for use in EC commands.
		require
			configured: not project_config_path.is_empty and not project_target_name.is_empty
		local
			l_project_dir: STRING_32
			l_config: STRING_32
		do
			l_config := project_config_path.twin

			-- Derive project directory (folder containing the ECF)
			l_project_dir := l_config.twin

			-- Fix: Convert character code to NATURAL_32 for strict type compatibility
			if l_project_dir.has_code (('\').code.to_natural_32) then
				l_project_dir.keep_head (l_project_dir.last_index_of ('\', l_project_dir.count) - 1)
			end

			Result := [project_config_path, project_target_name, l_project_dir]
		ensure
			result_attached: Result /= Void
			config_match: Result.config ~ project_config_path
			target_match: Result.target ~ project_target_name
		end

	config_target_path (a_full_path: STRING_32): TUPLE [config, target, project_path: STRING_32]
			-- Parse a full ECF path into constituent parts required for EC arguments.
			-- Returns [Configuration File Path, Target Name, Project Directory].
			-- WARNING: Heuristic only. Assumes Target Name == Filename.
			-- Use `make_with_path_and_target` to avoid this assumption.
		require
			path_attached: a_full_path /= Void
			is_ecf: a_full_path.ends_with (".ecf")
		local
			l_config, l_target, l_project_path: STRING_32
			l_splitter: LIST [STRING_32]
		do
			-- 1. Config is the full path
			l_config := a_full_path.twin

			-- 2. Extract Target Name (assuming filename matches target name as per common convention)
			l_splitter := l_config.split ('\')

			check split_valid: not l_splitter.is_empty end
			-- Splitting a string should result in at least one token.

			l_target := l_splitter.last.twin
			l_target.replace_substring_all (".ecf", "")

			-- 3. Project Path is the directory containing the ECF
			l_project_path := l_config.twin
			l_project_path.replace_substring_all ("\" + l_splitter.last, "")

			Result := [l_config, l_target, l_project_path]
		ensure
			result_attached: Result /= Void
			config_set: Result.config.is_equal (a_full_path)
			target_not_empty: not Result.target.is_empty
			project_path_not_empty: not Result.project_path.is_empty
		end

feature -- Access (Convenience Aliases)

	last_melt: STRING_32
			-- Output from the last melt operation.
			-- (Semantic alias for `last_output`).
		require
			output_attached: last_output /= Void
		do
			Result := last_output
		ensure
			result_is_output: Result = last_output
		end

	last_quick_melt: STRING_32
			-- Output from the last quick_melt operation.
			-- (Semantic alias for `last_output`).
		require
			output_attached: last_output /= Void
		do
			Result := last_output
		ensure
			result_is_output: Result = last_output
		end

	last_flat: STRING_32
			-- Output from the last flat/flatshort operation.
			-- (Semantic alias for `last_output`).
		require
			output_attached: last_output /= Void
		do
			Result := last_output
		ensure
			result_is_output: Result = last_output
		end

feature -- Status Report

	is_last_execution_successful: BOOLEAN
			-- Did the last command exit with code 0?
		do
			Result := last_exit_code = 0
		ensure
			definition: Result = (last_exit_code = 0)
		end

feature -- EC Info Commands

	ec_environment: STRING_32
			-- Get EC environment info.
		do
			execute_ec (<<"-appinfo", "environment">>)
			Result := last_output
		ensure
			result_attached: Result /= Void
			output_updated: Result = last_output
		end

	ec_version: STRING_32
			-- Get EC version info.
		do
			execute_ec (<<"-appinfo", "version">>)
			Result := last_output
		ensure
			result_attached: Result /= Void
			output_updated: Result = last_output
		end

	ec_layout: STRING_32
			-- Get EC layout info.
		do
			execute_ec (<<"-appinfo", "layout">>)
			Result := last_output
		ensure
			result_attached: Result /= Void
			output_updated: Result = last_output
		end

feature -- EC Action Commands

	ec_quick_melt (a_config, a_target, a_project_path: READABLE_STRING_GENERAL)
			-- Perform a quick melt (compile changes only).
		require
			config_attached: a_config /= Void
			target_attached: a_target /= Void
			path_attached: a_project_path /= Void
		do
			-- Added "-batch" to prevent hangs
			execute_ec (<<"-config", a_config, "-target", a_target, "-project_path", a_project_path, "-batch", "-quick_melt">>)
		ensure
			output_captured: last_output /= Void
		end

	ec_melt (a_config, a_target, a_project_path: READABLE_STRING_GENERAL)
			-- Perform a standard melt.
		require
			config_attached: a_config /= Void
			target_attached: a_target /= Void
			path_attached: a_project_path /= Void
		do
			-- Added "-batch" to prevent hangs
			execute_ec (<<"-config", a_config, "-target", a_target, "-project_path", a_project_path, "-batch", "-melt">>)
		end

	ec_flat (a_config, a_target, a_project_path, a_class_name: READABLE_STRING_GENERAL)
			-- Generate flat view of `a_class_name`.
			-- EXAMPLE: ec -flat FAIL_APP -config eifmate.ecf -target eifmate_broken -batch -project_path d:\prod\eifmate
		require
			config_attached: a_config /= Void
			target_attached: a_target /= Void
			path_attached: a_project_path /= Void
			class_name_attached: a_class_name /= Void
		do
			-- Added "-batch" here as well for safety
			execute_ec (<<"-config", a_config, "-target", a_target, "-project_path", a_project_path, "-batch", "-flat", a_class_name>>)
		ensure
			output_captured: last_output /= Void
		end

	ec_flatshort (a_config, a_target, a_project_path, a_class_name: READABLE_STRING_GENERAL)
			-- Generate interface view (contract view) of `a_class_name`.
		require
			config_attached: a_config /= Void
			target_attached: a_target /= Void
			path_attached: a_project_path /= Void
			class_name_attached: a_class_name /= Void
		do
			-- Added "-batch"
			execute_ec (<<"-config", a_config, "-target", a_target, "-project_path", a_project_path, "-batch", "-flatshort", a_class_name>>)
		ensure
			output_captured: last_output /= Void
		end

feature -- Tuple Wrappers (Agent Helpers)

	ec_quick_melt_tuple (a_tuple: TUPLE [config, target, project_path: STRING_32])
			-- Wrapper for quick melt using a tuple argument.
		require
			tuple_attached: a_tuple /= Void
			config_in_tuple: a_tuple.config /= Void
			target_in_tuple: a_tuple.target /= Void
			path_in_tuple: a_tuple.project_path /= Void
		do
			ec_quick_melt (a_tuple.config, a_tuple.target, a_tuple.project_path)
		end

	ec_melt_tuple (a_tuple: TUPLE [config, target, project_path: STRING_32])
			-- Wrapper for melt using a tuple argument.
		require
			tuple_attached: a_tuple /= Void
			config_in_tuple: a_tuple.config /= Void
			target_in_tuple: a_tuple.target /= Void
			path_in_tuple: a_tuple.project_path /= Void
		do
			ec_melt (a_tuple.config, a_tuple.target, a_tuple.project_path)
		end

	ec_flat_tuple (a_tuple: TUPLE [config, target, project_path, class_name: STRING_32])
			-- Wrapper for flat view using a tuple argument.
		require
			tuple_attached: a_tuple /= Void
			config_in_tuple: a_tuple.config /= Void
			target_in_tuple: a_tuple.target /= Void
			path_in_tuple: a_tuple.project_path /= Void
			class_in_tuple: a_tuple.class_name /= Void
		do
			ec_flat (a_tuple.config, a_tuple.target, a_tuple.project_path, a_tuple.class_name)
		end

	ec_flatshort_tuple (a_tuple: TUPLE [config, target, project_path, class_name: STRING_32])
			-- Wrapper for flatshort view using a tuple argument.
		require
			tuple_attached: a_tuple /= Void
			config_in_tuple: a_tuple.config /= Void
			target_in_tuple: a_tuple.target /= Void
			path_in_tuple: a_tuple.project_path /= Void
			class_in_tuple: a_tuple.class_name /= Void
		do
			ec_flatshort (a_tuple.config, a_tuple.target, a_tuple.project_path, a_tuple.class_name)
		end

feature -- Execution

	execute_ec (a_args: ARRAY [READABLE_STRING_GENERAL])
			-- Execute ec.exe with given arguments.
			-- Captures all output (stdout + stderr merged).
		require
			args_attached: a_args /= Void
		local
			l_process: PROCESS
			l_buffer: SPECIAL [NATURAL_8]
			l_chunk: STRING_32
			l_factory: PROCESS_FACTORY
		do
			-- Reset state
			create last_output.make_empty
			last_errors.wipe_out
			last_exit_code := -1

			-- Create process
			create l_factory
			l_process := l_factory.process_launcher (
				ec_executable_path,
				a_args,
				Void -- Use current directory
			)

			-- Configure process
			l_process.set_hidden (True)
			l_process.redirect_output_to_stream
			l_process.redirect_error_to_same_as_output

			-- Launch and capture output
			l_process.launch

			if l_process.launched then
				-- Read output in chunks
				from
					create l_buffer.make_filled (0, 1024)
				invariant
					buffer_attached: l_buffer /= Void
					buffer_capacity_positive: l_buffer.capacity > 0
					output_attached: last_output /= Void
				until
					l_process.has_output_stream_closed or else
					l_process.has_output_stream_error
				loop
					l_buffer := l_buffer.aliased_resized_area_with_default (0, l_buffer.capacity)
					l_process.read_output_to_special (l_buffer)

					if l_buffer.count > 0 then
						-- Convert console encoding to UTF-32
						l_chunk := converter.console_encoding_to_utf32 (
							console_encoding,
							create {STRING_8}.make_from_c_substring ($l_buffer, 1, l_buffer.count)
						)
						l_chunk.prune_all ({CHARACTER_32} '%R')
						last_output.append (l_chunk)
					end
				end

				l_process.wait_for_exit
				last_exit_code := l_process.exit_code
			else
				last_errors.force ("Failed to launch " + ec_executable_path)
			end
		ensure
			output_captured: last_output /= Void
			errors_attached: last_errors /= Void
			valid_exit_code: last_exit_code >= -1
		end

feature {NONE} -- Implementation

	converter: LOCALIZED_PRINTER
			-- Encoding converter helper.
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	console_encoding: ENCODING
			-- Current console encoding.
		local
			l_system_encodings: SYSTEM_ENCODINGS
		once
			create l_system_encodings
			Result := l_system_encodings.console_encoding
		ensure
			result_attached: Result /= Void
		end

invariant
	executable_path_attached: ec_executable_path /= Void
	executable_path_not_empty: not ec_executable_path.is_empty
	output_attached: last_output /= Void
	errors_attached: last_errors /= Void
	valid_exit_code_range: last_exit_code >= -1

	-- Project Integrity Invariants
	project_config_path_attached: project_config_path /= Void
	project_target_name_attached: project_target_name /= Void
	consistent_configuration: project_config_path.is_empty = project_target_name.is_empty
	-- The above line ensures we either have BOTH a config and a target, or neither.

end
