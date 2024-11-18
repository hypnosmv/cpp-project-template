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

function(find_include_directories root_dir result_dirs)
    file(GLOB_RECURSE glob_dirs LIST_DIRECTORIES true "${root_dir}/*include")
    list(FILTER glob_dirs INCLUDE REGEX "/include$")
    set("${result_dirs}" "${glob_dirs}" PARENT_SCOPE)
endfunction()

file(GLOB_RECURSE MAIN_SOURCE_FILES "${SRC_DIR}*/main.cpp")

file(GLOB_RECURSE SOURCE_FILES "${SRC_DIR}/*.cpp")
list(FILTER SOURCE_FILES EXCLUDE REGEX "/main.cpp$")
find_include_directories("${SRC_DIR}" INCLUDE_DIRS)

file(GLOB_RECURSE UT_SOURCES "${UT_DIR}/*.cpp")
find_include_directories("${UT_DIR}" UT_INCLUDE_DIRS)

file(GLOB_RECURSE IT_SOURCES "${IT_DIR}/*.cpp")
find_include_directories("${IT_DIR}" IT_INCLUDE_DIRS)

########################################################################################################################

    #Libraries

function(create_static_library lib_name source_files include_dirs compiler_flags linker_flags)
    add_library("${lib_name}" STATIC "${source_files}")
    target_include_directories("${lib_name}" PUBLIC "${include_dirs}")
    target_compile_options("${lib_name}" PUBLIC "${compiler_flags}")
    target_link_options("${lib_name}" PUBLIC "${linker_flags}")
endfunction()

if(SOURCE_FILES)
    create_static_library(
        debug_lib
        "${SOURCE_FILES}"
        "${INCLUDE_DIRS}"
        "${DEBUG_COMPILER_FLAGS}"
        "${DEBUG_LINKER_FLAGS}")

    create_static_library(
        release_lib
        "${SOURCE_FILES}"
        "${INCLUDE_DIRS}"
        "${RELEASE_COMPILER_FLAGS}"
        "${RELEASE_LINKER_FLAGS}")
endif()

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

    #Executables

function(create_executable exec_name main_source_files lib_source_files lib_name additional_libs)
    if(main_source_files)
        add_executable("${exec_name}" "${main_source_files}")
        set_target_properties("${exec_name}" PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")
        if(lib_source_files)
            target_link_libraries("${exec_name}" PRIVATE "${lib_name}")
        endif()
        target_link_libraries("${exec_name}" PRIVATE ${additional_libs})
    endif()
endfunction()

set(ADDITIONAL_LIBS)
create_executable(debug "${MAIN_SOURCE_FILES}" "${SOURCE_FILES}" debug_lib "${ADDITIONAL_LIBS}")
create_executable(release "${MAIN_SOURCE_FILES}" "${SOURCE_FILES}" release_lib "${ADDITIONAL_LIBS}")

set(TEST_LIBS gtest_main)
create_executable(ut "${UT_SOURCES}" "${SOURCE_FILES}" debug_lib "${TEST_LIBS}")
create_executable(it "${IT_SOURCES}" "${SOURCE_FILES}" debug_lib "${TEST_LIBS}")

########################################################################################################################
