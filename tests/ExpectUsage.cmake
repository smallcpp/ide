if(NOT DEFINED PROGRAM)
    message(FATAL_ERROR "usage check is missing a path")
endif()

execute_process(
    COMMAND "${PROGRAM}" --bogus
    RESULT_VARIABLE run_status
    OUTPUT_VARIABLE program_output
    ERROR_VARIABLE program_error)
if(NOT run_status EQUAL 2)
    message(FATAL_ERROR
        "${PROGRAM} exited ${run_status}, expected 2")
endif()
if(NOT program_error MATCHES "IDE0001")
    message(FATAL_ERROR "stderr was '${program_error}'")
endif()
