note
	description: "[
		Root class for EifMate CLI executable.
		Handles command line arguments and invokes EM_CLI for processing.
		
		Usage:
			eifmate compile D:/projects/myapp/myapp.ecf myapp_cli
			eifmate query flatshort D:/projects/myapp/myapp.ecf myapp_cli MY_CLASS
			eifmate --json request.json
			
		In the simplest case, reads JSON from stdin and writes response to stdout:
			echo '{...}' | eifmate
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_CLI_APP

inherit
	ARGUMENTS_32

	EM_CONSTANTS

create
	make

feature {NONE} -- Initialization

    make
            -- Run a Windows command and print its output.
        local
            p: PROCESS_IMP
            output: STRING
        do
            create p.make ("cmd.exe", <<" /c", "ipconfig">>, "")
            p.redirect_output_to_stream
            p.redirect_error_to_same_as_output

            p.launch

            from
            until
                p.has_exited
            loop
            	do_nothing -- output???
            end

            p.wait_for_exit
            io.put_string ("%NExit code: " + p.exit_code.out)
        end


--	make
--			-- Process command line request
--		local
--			l_cli: EM_CLI
--			l_response: EM_RESPONSE
--			l_request_json: STRING_8
--		do
--			create l_cli.make

--			if argument_count = 0 then
--				-- No arguments - read JSON from stdin
--				l_request_json := read_stdin
--				if not l_request_json.is_empty then
--					l_response := l_cli.process_request (l_request_json)
--					print (l_response.to_json_string)
--				else
--					print_usage
--				end

--			elseif argument_count >= 1 and then argument (1).same_string_general ("--json") then
--				-- Read from JSON file
--				if argument_count >= 2 then
--					l_response := l_cli.process_request_from_file (
--						create {PATH}.make_from_string (argument (2))
--					)
--					print (l_response.to_json_string)
--				else
--					io.error.put_string ("Error: --json requires file path%N")
--					print_usage
--				end

--			elseif argument_count >= 1 and then argument (1).same_string_general ("--help") then
--				print_usage

--			else
--				-- Build JSON from command line arguments
--				l_request_json := build_request_from_args
--				if not l_request_json.is_empty then
--					l_response := l_cli.process_request (l_request_json)
--					print (l_response.to_json_string)
--				else
--					io.error.put_string ("Error: Invalid arguments%N")
--					print_usage
--				end
--			end
--		end

feature {NONE} -- Implementation

	read_stdin: STRING_8
			-- Read JSON from standard input
		local
			l_line: STRING_8
		do
			create Result.make (1024)

--			from
--				io.read_line
--			until
--				io.to_next_line
--			loop
--				io.read_line
--				l_line := io.last_string
--				Result.append (l_line)
--				if not io.end_of_file then
--					Result.append ("%N")
--				end
--			end
		ensure
			result_attached: Result /= Void
		end

	build_request_from_args: STRING_8
			-- Build JSON request from command line arguments
		local
			l_obj: SIMPLE_JSON_OBJECT
		do
			create Result.make_empty

			if argument_count >= 3 then
				create l_obj.make

				-- First argument is request type
				l_obj.put_string (argument (1).to_string_8, Json_key_request_type).do_nothing

				-- Second argument is ECF path
				l_obj.put_string (argument (2).to_string_8, Json_key_ecf_path).do_nothing

				-- Third argument is target
				l_obj.put_string (argument (3).to_string_8, Json_key_target).do_nothing

				-- Fourth argument (if present) depends on request type
				if argument_count >= 4 then
					if argument (1).same_string_general ("query") then
						-- For queries: 4th arg is query type, 5th is class name
						l_obj.put_string (argument (4).to_string_8, Json_key_query_type).do_nothing

						if argument_count >= 5 then
							l_obj.put_string (argument (5).to_string_8, Json_key_class_name).do_nothing
						end
					end
				end

				Result := l_obj.representation
			end
		ensure
			result_attached: Result /= Void
		end

	print_usage
			-- Print usage information
		do
			io.put_string ("EifMate - Claude-to-EiffelStudio Bridge v" + Eifmate_version + "%N%N")
			io.put_string ("Usage:%N")
			io.put_string ("  eifmate                           Read JSON request from stdin%N")
			io.put_string ("  eifmate --json <file>             Read JSON request from file%N")
			io.put_string ("  eifmate --help                    Show this help%N")
			io.put_string ("%N")
			io.put_string ("  eifmate compile <ecf> <target>                 Quick compile%N")
			io.put_string ("  eifmate compile_clean <ecf> <target>           Clean compile%N")
			io.put_string ("  eifmate freeze <ecf> <target>                  Freeze compile%N")
			io.put_string ("  eifmate finalize <ecf> <target>                Finalize compile%N")
			io.put_string ("  eifmate test <ecf> <target>                    Run tests%N")
			io.put_string ("  eifmate query <type> <ecf> <target> <class>    Query code%N")
			io.put_string ("%N")
			io.put_string ("Query types:%N")
			io.put_string ("  flat         - Flat view (all features with inheritance)%N")
			io.put_string ("  flatshort    - Interface view (public features only)%N")
			io.put_string ("  clients      - Classes that use the specified class%N")
			io.put_string ("  suppliers    - Classes used by the specified class%N")
			io.put_string ("%N")
			io.put_string ("Examples:%N")
			io.put_string ("  eifmate compile D:/myapp/myapp.ecf myapp_cli%N")
			io.put_string ("  eifmate query flatshort D:/myapp/myapp.ecf myapp_cli MY_CLASS%N")
			io.put_string ("  echo %"{%"type%":%"compile%",...}' | eifmate%N")
		end

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
