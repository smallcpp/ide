if(NOT DEFINED PROGRAM OR NOT DEFINED MODE)
    message(FATAL_ERROR "cli check is missing a path")
endif()

if(MODE STREQUAL "help")
    set(cli_arg "--help")
    set(cli_needle "usage: ide")
elseif(MODE STREQUAL "version")
    set(cli_arg "--version")
    set(cli_needle "ide 0.0.1")
else()
    message(FATAL_ERROR "unknown cli mode ${MODE}")
endif()

execute_process(
    COMMAND "${PROGRAM}" "${cli_arg}"
    RESULT_VARIABLE run_status
    OUTPUT_VARIABLE program_output
    ERROR_VARIABLE program_error)
if(NOT run_status EQUAL 0)
    message(FATAL_ERROR
        "${PROGRAM} exited ${run_status}: ${program_error}")
endif()
if(NOT program_output MATCHES "${cli_needle}")
    message(FATAL_ERROR "${PROGRAM} wrote '${program_output}'")
endif()
