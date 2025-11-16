note
	description: "[
		Compilation request from Claude MCP client.
		
		Parses JSON request containing:
		- Project path (ECF file)
		- Target name
		- Action (compile, freeze, finalize)
		- Optional: specific classes to compile
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_REQUEST

create
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			-- Parse request from JSON string
		require
			json_attached: a_json /= Void
			not_empty: not a_json.is_empty
		do
			-- TODO: Parse JSON into attributes
		end

feature -- Access

	project_path: detachable STRING_32
			-- Path to ECF file

	target_name: detachable STRING_32
			-- Target name to compile

	action: detachable STRING_32
			-- Action: "compile", "freeze", "finalize"

	classes: detachable ARRAYED_LIST [STRING_32]
			-- Optional: specific classes to compile

feature -- Status report

	is_valid: BOOLEAN
			-- Is request valid?
		do
			Result := attached project_path and then
					  attached target_name and then
					  attached action
		ensure
			definition: Result = (attached project_path and then
								  attached target_name and then
								  attached action)
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
