note
	description: "[
		Additional constants for AI-TODO workflow.
		
		INSTRUCTIONS:
		Add these constants to your existing EM_CONSTANTS class.
		These provide named constants for:
		- Obsidian folder names
		- AI-TODO marker strings
		- File extensions
		- Request/response identifiers
	]"

class
	EM_CONSTANTS_AI_TODO_ADDITIONS

feature -- Obsidian folders

	Obsidian_out_folder: STRING_8 = "out-to-AI"
			-- Folder name for requests to Claude

	Obsidian_in_folder: STRING_8 = "in-from-AI"
			-- Folder name for responses from Claude

feature -- AI-TODO markers

	Ai_todo_marker: STRING_8 = "AI-TODO"
			-- Comment marker for AI tasks
			-- Usage: -- AI-TODO: Description of task

	Ai_todo_class_marker: STRING_8 = "AI-TODO-CLASS"
			-- Marker for class-wide tasks

	Ai_todo_feature_marker: STRING_8 = "AI-TODO-FEATURE"
			-- Marker for feature-wide tasks

feature -- Response format

	Response_header_prefix: STRING_8 = "RESPONSE_TO:"
			-- Header comment prefix in response files
			-- Usage: -- RESPONSE_TO: req_20241120_143022

	Request_id_prefix: STRING_8 = "req_"
			-- Prefix for generated request IDs

feature -- File extensions

	Eiffel_extension: STRING_8 = ".e"
			-- Eiffel source file extension

	Markdown_extension: STRING_8 = ".md"
			-- Markdown file extension

	Manifest_filename: STRING_8 = "REQUEST.md"
			-- Name of request manifest file

feature -- Findstr command

	Findstr_command_template: STRING_8 = "cmd /c %"cd /d {PROJECT_PATH} && findstr /S /M /C:%"AI-TODO%" *.e%""
			-- Template for Windows findstr command
			-- Replace {PROJECT_PATH} with actual path

feature -- Buffer sizes

	Todo_text_buffer_size: INTEGER = 512
			-- Maximum expected TODO text length

	File_copy_buffer_size: INTEGER = 4096
			-- Buffer size for file copying operations

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
