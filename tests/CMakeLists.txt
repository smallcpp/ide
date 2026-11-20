set(IDE_TESTS
    buffer
    toml
    document
    syntax
    settings
    project
    explorer
    lsp
    session)

foreach(name ${IDE_TESTS})
    set(source "${CMAKE_CURRENT_SOURCE_DIR}/test_${name}.scpp")
    set(program "${CMAKE_SOURCE_DIR}/bin/test-${name}")
    set(link_dir "${CMAKE_BINARY_DIR}/link-test-${name}")
    add_custom_command(
        OUTPUT "${program}"
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_SOURCE_DIR}/bin"
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${link_dir}"
        COMMAND "${CMAKE_COMMAND}" -E chdir "${link_dir}"
                "${SCPP}" ${SCPP_FLAGS} -o "${program}"
                "${source}" ${IDE_LIB_SOURCES} -l pthread
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        DEPENDS "${source}" ${IDE_LIB_SOURCES} ${IDE_HEADERS} "${SCPP}"
        COMMENT "Compiling tests/test_${name}.scpp"
        VERBATIM)
    add_custom_target(test-${name} DEPENDS "${program}")
    add_test(
        NAME test-${name}
        COMMAND ${CMAKE_COMMAND}
            -DPROGRAM=${program}
            "-DNEEDLE=test-${name} ok"
            -P ${CMAKE_CURRENT_SOURCE_DIR}/ExpectOk.cmake)
endforeach()

add_test(
    NAME ide-help
    COMMAND ${CMAKE_COMMAND}
        -DPROGRAM=${IDE_PROGRAM}
        -DMODE=help
        -P ${CMAKE_CURRENT_SOURCE_DIR}/ExpectOut.cmake)
add_test(
    NAME ide-version
    COMMAND ${CMAKE_COMMAND}
        -DPROGRAM=${IDE_PROGRAM}
        -DMODE=version
        -P ${CMAKE_CURRENT_SOURCE_DIR}/ExpectOut.cmake)
add_test(
    NAME ide-usage
    COMMAND ${CMAKE_COMMAND}
        -DPROGRAM=${IDE_PROGRAM}
        -P ${CMAKE_CURRENT_SOURCE_DIR}/ExpectUsage.cmake)
