#!/bin/bash

commands=(
    "prep"
    "clean"
    "all"
    "debug"
    "release"
    "ut"
    "it")

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
build_dir="$script_dir/build"
bin_dir="$build_dir/bin"

if [ "$#" -ne 1 ]; then
    echo "Exactly one argument required: ${commands[@]}"
    exit 2
fi

compile_cmake_target() {
    cmake --build "$build_dir" --target="$1"
    cmake_exit_code="$?"

    if [ "$cmake_exit_code" -eq 1 ]; then
        echo "Enter: ./run.sh prep"
        return 1
    elif [ "$cmake_exit_code" -eq 2 ]; then
        echo "Files needed to compile the target are missing"
        return 1
    fi

    return 0
}

if [ "$1" = "${commands[0]}" ]; then
    cmake -S "$script_dir" -B "$build_dir"

elif [ "$1" = "${commands[1]}" ]; then
    rm -rf "$build_dir"

elif [ "$1" = "${commands[2]}" ]; then
    compile_cmake_target all

elif [ "$1" = "${commands[3]}" ]; then
    compile_cmake_target debug

elif [ "$1" = "${commands[4]}" ]; then
    compile_cmake_target release

elif [ "$1" = "${commands[5]}" ]; then
    compile_cmake_target ut
    if [ "$?" -eq 0 ]; then
        "$bin_dir"/ut
    else
        exit 1
    fi

elif [ "$1" = "${commands[6]}" ]; then
    compile_cmake_target it
    if [ "$?" -eq 0 ]; then
        "$bin_dir"/it
    else
        exit 1
    fi

else
    echo "Unknown command: $1"
    exit 2
fi
