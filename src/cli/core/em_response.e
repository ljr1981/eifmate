note
	description: "[
		Compilation response sent back to Claude MCP client.
		
		Contains:
		- Success/failure status
		- Compiler output
		- Error messages with locations
		- Warnings
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_RESPONSE

create
	make_success,
	make_failure

feature {NONE} -- Initialization

	make_success (a_output: STRING)
			-- Create successful response with compiler output
		require
			output_attached: a_output /= Void
		do
			is_success := True
			output := a_output
			create errors.make (0)
			create warnings.make (0)
		ensure
			success: is_success
			output_set: output = a_output
		end

	make_failure (a_errors: ARRAYED_LIST [STRING])
			-- Create failure response with error messages
		require
			errors_attached: a_errors /= Void
		do
			is_success := False
			errors := a_errors
			create output.make_empty
			create warnings.make (0)
		ensure
			failure: not is_success
			errors_set: errors = a_errors
		end

feature -- Access

	is_success: BOOLEAN
			-- Was compilation successful?

	output: STRING
			-- Compiler output text

	errors: ARRAYED_LIST [STRING]
			-- Error messages

	warnings: ARRAYED_LIST [STRING]
			-- Warning messages

feature -- Conversion

	to_json: STRING
			-- Convert to JSON string for MCP response
		do
			create Result.make (256)
			-- TODO: Build JSON response
		ensure
			result_attached: Result /= Void
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
