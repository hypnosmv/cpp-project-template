#!/bin/bash

build_system="Ninja"
gtest_flags="--gtest_brief=1"

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
}

run_gtest_target() {
    "$bin_dir"/"$1" "$gtest_flags"
}

if [ "$1" = "${commands[0]}" ]; then
    cmake -S "$script_dir" -B "$build_dir" -G "$build_system"

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
    run_gtest_target ut

elif [ "$1" = "${commands[6]}" ]; then
    compile_cmake_target it
    run_gtest_target it

else
    echo "Unknown command: $1"
    exit 2
fi
