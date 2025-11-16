note
	description: "[
		EifMate project constants.
		
		Defines:
		- Version information
		- Default paths
		- Action strings
		- JSON field names
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_CONSTANTS

feature -- Version

	Version_major: INTEGER = 0
			-- Major version number

	Version_minor: INTEGER = 1
			-- Minor version number

	Version_patch: INTEGER = 0
			-- Patch version number

	version_string: STRING
			-- Version as string
		once
			create Result.make (10)
			Result.append (Version_major.out)
			Result.append (".")
			Result.append (Version_minor.out)
			Result.append (".")
			Result.append (Version_patch.out)
		ensure
			result_attached: Result /= Void
		end

feature -- Compiler actions

	Action_compile: STRING_32 = "compile"
			-- Compile action

	Action_freeze: STRING_32 = "freeze"
			-- Freeze action

	Action_finalize: STRING_32 = "finalize"
			-- Finalize action

	Action_clean: STRING_32 = "clean"
			-- Clean action

feature -- JSON field names

	Field_project_path: STRING_32 = "project_path"
			-- JSON field for project path

	Field_target: STRING_32 = "target"
			-- JSON field for target name

	Field_action: STRING_32 = "action"
			-- JSON field for action

	Field_classes: STRING_32 = "classes"
			-- JSON field for class list

	Field_success: STRING_32 = "success"
			-- JSON field for success flag

	Field_output: STRING_32 = "output"
			-- JSON field for compiler output

	Field_errors: STRING_32 = "errors"
			-- JSON field for error list

	Field_warnings: STRING_32 = "warnings"
			-- JSON field for warning list

feature -- Defaults

	Default_timeout_seconds: INTEGER = 300
			-- Default compilation timeout (5 minutes)

	Max_output_size: INTEGER = 1_000_000
			-- Maximum output size (1MB)

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
