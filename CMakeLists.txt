cmake_minimum_required(VERSION 3.16)
project(ide LANGUAGES NONE)

# A fresh configuration installs to $HOME/opt/<project>. HOME is expanded
# here, so the cache holds an absolute path. scripts/install can pass
# another prefix for one run. On CMake 3.29 and newer, a new build
# directory also takes CMAKE_INSTALL_PREFIX from the environment. A later
# configure keeps the cached prefix.
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT
   AND (CMAKE_VERSION VERSION_LESS 3.29
        OR NOT DEFINED ENV{CMAKE_INSTALL_PREFIX}))
    if("$ENV{HOME}" STREQUAL "")
        message(FATAL_ERROR
            "Cannot select the default install prefix: HOME is not set. "
            "Set HOME to an absolute path.")
    endif()
    if(NOT IS_ABSOLUTE "$ENV{HOME}")
        message(FATAL_ERROR
            "Cannot select the default install prefix: HOME must be absolute "
            "(got '$ENV{HOME}').")
    endif()
    get_filename_component(install_home "$ENV{HOME}" ABSOLUTE)
    set(CMAKE_INSTALL_PREFIX "${install_home}/opt/${PROJECT_NAME}" CACHE PATH
        "Install path prefix, prepended onto install directories." FORCE)
    set(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT FALSE)
endif()

# Binaries land next to the checkout, as they do for the compiler.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")

# `build test` is `cmake --build build --target test`. That target builds
# the program first, then CTest runs the suite.
set(CMAKE_SKIP_TEST_ALL_DEPENDENCY FALSE)
enable_testing()

# `scpp` on PATH wins. The default install prefix is $HOME/opt/smallcpp.
set(SMALLCPP_DEFAULT_BIN "")
if(IS_ABSOLUTE "$ENV{HOME}")
    set(SMALLCPP_DEFAULT_BIN "$ENV{HOME}/opt/smallcpp/bin")
endif()
if(SCPP AND NOT EXISTS "${SCPP}")
    unset(SCPP CACHE)
endif()
find_program(SCPP NAMES scpp PATHS ${SMALLCPP_DEFAULT_BIN})
if(NOT SCPP)
    unset(SCPP CACHE)
    message(FATAL_ERROR
        "scpp was not found on PATH or in \$HOME/opt/smallcpp/bin. "
        "Install smallcpp and run scripts/setup again.")
endif()

set(IDE_SOURCE "${CMAKE_SOURCE_DIR}/src/ide.scpp")
set(IDE_PROGRAM "${CMAKE_SOURCE_DIR}/bin/ide")

set(IDE_UNITS
    "${CMAKE_SOURCE_DIR}/src/ide.scpp"
    "${CMAKE_SOURCE_DIR}/src/ui.scpp"
    "${CMAKE_SOURCE_DIR}/src/session.scpp"
    "${CMAKE_SOURCE_DIR}/src/lsp.scpp"
    "${CMAKE_SOURCE_DIR}/src/explorer.scpp"
    "${CMAKE_SOURCE_DIR}/src/project.scpp"
    "${CMAKE_SOURCE_DIR}/src/settings.scpp"
    "${CMAKE_SOURCE_DIR}/src/document.scpp"
    "${CMAKE_SOURCE_DIR}/src/syntax.scpp"
    "${CMAKE_SOURCE_DIR}/src/toml.scpp"
    "${CMAKE_SOURCE_DIR}/src/buffer.scpp"
    "${CMAKE_SOURCE_DIR}/src/util.scpp")

set(SCPP_FLAGS "")
if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    list(APPEND SCPP_FLAGS "-g")
endif()

set(IDE_LIBS
    -l smallcpp_gtk
    -l gtk-4
    -l gio-2.0
    -l gobject-2.0
    -l glib-2.0
    -l pango-1.0
    -l pangocairo-1.0
    -l cairo
    -l pthread)

add_custom_command(
    OUTPUT "${IDE_PROGRAM}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_SOURCE_DIR}/bin"
    COMMAND "${SCPP}" ${SCPP_FLAGS} -o "${IDE_PROGRAM}"
            "${IDE_SOURCE}" ${IDE_LIBS}
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    DEPENDS ${IDE_UNITS} "${SCPP}"
    COMMENT "Compiling src/ide.scpp"
    VERBATIM)
add_custom_target(ide ALL DEPENDS "${IDE_PROGRAM}")

# Copy the built application. This checkout is not the compiler, so the
# install does not write a config file. LIBDIR is set first because this
# project enables no language, and GNUInstallDirs warns otherwise.
if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
    set(CMAKE_INSTALL_LIBDIR "lib" CACHE PATH "Object code libraries")
endif()
include(GNUInstallDirs)
install(PROGRAMS "${IDE_PROGRAM}"
    DESTINATION "${CMAKE_INSTALL_BINDIR}")

add_subdirectory(tests)
