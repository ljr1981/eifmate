note
	description: "[
		Represents the location of a compiler error.
		Includes class name, feature name, line number, and file path.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_ERROR_LOCATION

create
	make,
	make_simple

feature {NONE} -- Initialization

	make (a_class_name: STRING; a_feature_name: STRING; a_line_number: INTEGER; a_file_path: STRING)
			-- Initialize with full location information
		require
			class_name_attached: a_class_name /= Void
			feature_name_attached: a_feature_name /= Void
			line_number_positive: a_line_number > 0
			file_path_attached: a_file_path /= Void
		do
			class_name := a_class_name
			feature_name := a_feature_name
			line_number := a_line_number
			file_path := a_file_path
		ensure
			class_name_set: class_name ~ a_class_name
			feature_name_set: feature_name ~ a_feature_name
			line_number_set: line_number = a_line_number
			file_path_set: file_path ~ a_file_path
		end

	make_simple (a_class_name: STRING; a_line_number: INTEGER)
			-- Initialize with minimal location information
		require
			class_name_attached: a_class_name /= Void
			line_number_positive: a_line_number > 0
		do
			class_name := a_class_name
			create feature_name.make_empty
			line_number := a_line_number
			create file_path.make_empty
		ensure
			class_name_set: class_name ~ a_class_name
			line_number_set: line_number = a_line_number
		end

feature -- Access

	class_name: STRING
			-- Name of class where error occurred

	feature_name: STRING
			-- Name of feature where error occurred (if known)

	line_number: INTEGER
			-- Line number where error occurred

	file_path: STRING
			-- Full path to source file (if known)

feature -- Status report

	has_feature_name: BOOLEAN
			-- Is feature name known?
		do
			Result := not feature_name.is_empty
		end

	has_file_path: BOOLEAN
			-- Is file path known?
		do
			Result := not file_path.is_empty
		end

feature -- Output

	formatted_output: STRING
			-- Formatted location string
		do
			create Result.make (100)
			
			Result.append ("Class: ")
			Result.append (class_name)
			Result.append ("%N")
			
			if has_feature_name then
				Result.append ("Feature: ")
				Result.append (feature_name)
				Result.append ("%N")
			end
			
			Result.append ("Line: ")
			Result.append (line_number.out)
			Result.append ("%N")
			
			if has_file_path then
				Result.append ("File: ")
				Result.append (file_path)
				Result.append ("%N")
			end
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

invariant
	class_name_attached: class_name /= Void
	feature_name_attached: feature_name /= Void
	line_number_positive: line_number > 0
	file_path_attached: file_path /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
