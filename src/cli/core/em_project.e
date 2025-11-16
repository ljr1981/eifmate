note
	description: "[
		Eiffel project representation (ECF file).
		
		Parses ECF to extract:
		- Available targets
		- Project name
		- Root class/feature
		- Library dependencies
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_PROJECT

create
	make_from_path

feature {NONE} -- Initialization

	make_from_path (a_path: STRING_32)
			-- Initialize from ECF file path
		require
			path_attached: a_path /= Void
			not_empty: not a_path.is_empty
		do
			path := a_path
			create targets.make (0)
			-- TODO: Parse ECF file
		ensure
			path_set: path = a_path
		end

feature -- Access

	path: STRING_32
			-- Path to ECF file

	project_name: detachable STRING_32
			-- Project name from ECF

	targets: ARRAYED_LIST [STRING_32]
			-- Available target names

	root_class: detachable STRING_32
			-- Root class name (if any)

	root_feature: detachable STRING_32
			-- Root feature name (if any)

feature -- Status report

	is_valid: BOOLEAN
			-- Is ECF file valid?
		do
			-- TODO: Check if file exists and is valid XML
			Result := True
		end

	has_target (a_name: STRING_32): BOOLEAN
			-- Does project have target named `a_name'?
		require
			name_attached: a_name /= Void
		do
			Result := targets.has (a_name)
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
