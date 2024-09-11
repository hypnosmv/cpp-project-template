########################################################################################################################

    #Project

cmake_minimum_required(VERSION 3.15)
project(BlankProject)
set(CMAKE_CXX_STANDARD 20)

########################################################################################################################

    #Variables

set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")
set(UT_DIR "${CMAKE_SOURCE_DIR}/test/ut")
set(IT_DIR "${CMAKE_SOURCE_DIR}/test/it")

########################################################################################################################

    #Flags

set(DEBUG_COMPILER_FLAGS -g -O0 -pedantic -Wall -Wextra -Wsign-conversion -fsanitize=address,leak,undefined)
set(DEBUG_LINKER_FLAGS -fsanitize=address,leak,undefined)
set(RELEASE_COMPILER_FLAGS -O2)
set(RELEASE_LINKER_FLAGS)

########################################################################################################################

    #Glob find files

file(GLOB_RECURSE SOURCE_FILES "${SRC_DIR}/*.cpp")
list(FILTER SOURCE_FILES EXCLUDE REGEX "/main.cpp$")

file(GLOB_RECURSE INCLUDE_DIRS LIST_DIRECTORIES true "${SRC_DIR}/*include")
list(FILTER INCLUDE_DIRS INCLUDE REGEX "/include$")

file(GLOB_RECURSE MAIN_SOURCE_FILES "${SRC_DIR}*/main.cpp")
file(GLOB_RECURSE UT_SOURCES "${UT_DIR}/*.cpp")
file(GLOB_RECURSE IT_SOURCES "${IT_DIR}/*.cpp")

########################################################################################################################

    #Google test

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0
)
FetchContent_MakeAvailable(googletest)

########################################################################################################################

    #Debug library

if(SOURCE_FILES)
    add_library(debug_lib STATIC ${SOURCE_FILES})
    target_include_directories(debug_lib PUBLIC ${INCLUDE_DIRS})

    target_compile_options(debug_lib PUBLIC ${DEBUG_COMPILER_FLAGS})
    target_link_options(debug_lib PUBLIC ${DEBUG_LINKER_FLAGS})
endif()

########################################################################################################################

    #Relase library

if(SOURCE_FILES)
    add_library(release_lib STATIC ${SOURCE_FILES})
    target_include_directories(release_lib PUBLIC ${INCLUDE_DIRS})

    target_compile_options(release_lib PUBLIC ${RELEASE_COMPILER_FLAGS})
    target_link_options(release_lib PUBLIC ${RELEASE_LINKER_FLAGS})
endif()

########################################################################################################################

    #Debug executable

if(MAIN_SOURCE_FILES)
    add_executable(debug ${MAIN_SOURCE_FILES})
    set_target_properties(debug PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")

    if(SOURCE_FILES)
        target_link_libraries(debug PRIVATE debug_lib)
    endif()
endif()

########################################################################################################################

    #Release executable

if(MAIN_SOURCE_FILES)
    add_executable(release ${MAIN_SOURCE_FILES})
    set_target_properties(release PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")

    if(SOURCE_FILES)
        target_link_libraries(release PRIVATE release_lib)
    endif()
endif()

########################################################################################################################

    #UT executable

if(UT_SOURCES)
    add_executable(ut ${UT_SOURCES})
    set_target_properties(ut PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")

    target_link_libraries(ut PRIVATE gtest_main)
    if(SOURCE_FILES)
        target_link_libraries(ut PRIVATE debug_lib)
    endif()
endif()

########################################################################################################################

    #IT executable

if(IT_SOURCES)
    add_executable(it ${IT_SOURCES})
    set_target_properties(it PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")

    target_link_libraries(it PRIVATE gtest_main)
    if(SOURCE_FILES)
        target_link_libraries(it PRIVATE debug_lib)
    endif()
endif()

########################################################################################################################
