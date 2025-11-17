note
    description: "Eiffel compiler wrapper for executing ec.exe"

class
    EM_COMPILER

--inherit
--    RANDOMIZER  -- For any utility features you might need

create
    make

feature {NONE} -- Initialization

    make
            -- Initialize compiler wrapper
        do
            create last_output.make_empty
            create last_errors.make (0)
            last_exit_code := -1
            ec_executable_path := "ec.exe"
        ensure
            output_initialized: last_output /= Void
            errors_initialized: last_errors /= Void
        end

feature -- Access

    ec_executable_path: STRING_32
            -- Path to ec.exe executable

    last_output: STRING_32
            -- Captured output from last execution

    last_errors: ARRAYED_LIST [STRING_32]
            -- Parsed error messages

    last_exit_code: INTEGER
            -- Exit code from last execution

feature -- Execution

    execute_ec (a_args: ARRAY [STRING_32])
            -- Execute ec.exe with given arguments
            -- Captures all output (stdout + stderr merged)
        require
            args_attached: a_args /= Void
        local
            l_process: PROCESS
            l_buffer: SPECIAL [NATURAL_8]
            l_chunk: STRING_32
        do
            -- Reset state
            create last_output.make_empty
            last_errors.wipe_out
            last_exit_code := -1

            -- Create process
            l_process := (create {PROCESS_FACTORY}).process_launcher (
                ec_executable_path,
                a_args,
                Void  -- Use current directory
            )

            -- Configure process
            l_process.set_hidden (True)
            l_process.redirect_output_to_stream
            l_process.redirect_error_to_same_as_output

            -- Launch and capture output
            l_process.launch

            if l_process.launched then
                -- Read output in chunks
                from
                    create l_buffer.make_filled (0, 512)
                until
                    l_process.has_output_stream_closed or else
                    l_process.has_output_stream_error
                loop
                    l_buffer := l_buffer.aliased_resized_area_with_default (0, l_buffer.capacity)
                    l_process.read_output_to_special (l_buffer)

                    -- Convert console encoding to UTF-32
                    l_chunk := converter.console_encoding_to_utf32 (
                        console_encoding,
                        create {STRING_8}.make_from_c_substring ($l_buffer, 1, l_buffer.count)
                    )
                    l_chunk.prune_all ({CHARACTER_32} '%R')
                    last_output.append (l_chunk)
                end

                l_process.wait_for_exit
                last_exit_code := l_process.exit_code
            else
                last_errors.force ("Failed to launch " + ec_executable_path)
            end
        ensure
            output_captured: last_output /= Void
        end

feature {NONE} -- Encoding

    converter: LOCALIZED_PRINTER
            -- Encoding converter
        once
            create Result
        end

    console_encoding: ENCODING
            -- Current console encoding
        once
            Result := (create {SYSTEM_ENCODINGS}).console_encoding
        end

end
