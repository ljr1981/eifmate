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
	make_empty,
	make_from_path

feature {NONE} -- Initialization

	make_empty
			-- Initialize empty
		do
			do_nothing
		end

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
		attribute
			create Result.make_empty
		end

	project_name: detachable STRING_32
			-- Project name from ECF

	targets: ARRAYED_LIST [STRING_32]
			-- Available target names
		attribute
			create Result.make (0)
		end

	root_class: detachable STRING_32
			-- Root class name (if any)

	root_feature: detachable STRING_32
			-- Root feature name (if any)

feature -- Settings

	set_path (a_path: like path)
			-- set `path' to `a_path'
		require
			not_empty: not a_path.is_empty
		do
			path := a_path
		end

	set_project_name (a_project_name: attached like project_name)
			-- set `project_name' to `a_project_name'
		require
			has_name: not a_project_name.is_empty
		do
			project_name := a_project_name
		ensure
			has_project_name: has_project_name
		end

	set_targets (a_targets: attached like targets)
			-- set `a_targets' into `a_target' array.
		require
			no_dupes: across a_targets as ic all not targets.has (ic) end
		do
			across a_targets as ic loop set_target (ic) end
		end

	set_target (a_target: STRING_32)
			-- set `a_target' into `a_target' array.
		require
			has_target: not a_target.is_empty
		do
			targets.put (a_target)
		ensure
			targets.has (a_target)
		end

	set_root_class (a_root_class: attached like root_class)
			-- set `root_class' to `a_root_class'
		require
			not_empty: not a_root_class.is_empty
		do
			root_class := a_root_class
		ensure
			set: root_class = a_root_class
		end

	set_root_feature (a_root_feature: attached like root_feature)
			-- set `root_feature' to `a_root_feature'
		require
			not_empty: not a_root_feature.is_empty
		do
			root_feature := a_root_feature
		ensure
			set: root_feature = a_root_feature
		end

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

	has_project_name: BOOLEAN
		do
			Result := attached project_name as al_name and then not al_name.is_empty
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
