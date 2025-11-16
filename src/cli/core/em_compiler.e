note
	description: "[
		Interface to EiffelStudio compiler via ec.exe.
		
		Executes compilation commands and captures output.
		Uses PROCESS library to run ec.exe as subprocess.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_COMPILER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize compiler interface
		do
			create last_output.make_empty
			create last_errors.make (0)
		ensure
			output_empty: last_output.is_empty
			errors_empty: last_errors.is_empty
		end

feature -- Access

	last_output: STRING
			-- Output from last compilation

	last_errors: ARRAYED_LIST [STRING]
			-- Errors from last compilation

feature -- Status report

	is_available: BOOLEAN
			-- Is ec.exe available?
		do
			-- TODO: Check if ec.exe exists
			Result := True
		end

feature -- Operations

	compile (a_project_path: STRING_32; a_target: STRING_32)
			-- Compile project at `a_project_path' for `a_target'
		require
			project_path_attached: a_project_path /= Void
			not_empty: not a_project_path.is_empty
			target_attached: a_target /= Void
			compiler_available: is_available
		do
			-- TODO: Execute ec.exe with PROCESS library
			-- ec -config path -target name -batch -c_compile
		end

	freeze (a_project_path: STRING_32; a_target: STRING_32)
			-- Freeze compile project
		require
			project_path_attached: a_project_path /= Void
			not_empty: not a_project_path.is_empty
			target_attached: a_target /= Void
			compiler_available: is_available
		do
			-- TODO: Execute ec.exe with freeze
			-- ec -config path -target name -batch -freeze
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
