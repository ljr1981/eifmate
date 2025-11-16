note
	description: "[
		EifMate CLI Application - Root class for command-line executable.
		
		Entry point for eifmate_cli.exe that processes compilation requests
		from Claude and returns structured responses.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_CLI_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Process single request from command line
		do
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
