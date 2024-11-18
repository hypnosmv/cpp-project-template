# C++ Project Template

Painless compilation of projects written in C++.

## Introduction

With just one command, simple C++ projects can be compiled.
```
./run.sh <command>
```
See [predefined commands](#predefined-commands).

## First run
> **Note:** CMake 3.15+ and Ninja required
```
git clone https://github.com/hypnosmv/cpp-project-template.git
cd cpp-project-template
chmod u+x run.sh
./run.sh prep
./run.sh all
```
The compiled binaries should now be located in `build/bin`.

## Workflow
If you create/delete .cpp or .hpp files, enter `./run.sh prep`.\
Stick to [suggested project structure](#suggested-project-structure) (no changes needed to the `CMakeLists.txt` file).\
Compile the desired target(s), e.g., `./run.sh ut`.

## Predefined commands

|command   |description                                          |
|----------|-----------------------------------------------------|
|`prep`    |configure project (essential to compile)             |
|`clean`   |delete configuration directory                       |
|`all`     |compile all available targets                        |
|`debug`   |compile debug target with additional debug flags     |
|`release` |compile release target                               |
|`ut`      |compile unit tests and run them                      |
|`it`      |compile integration tests and run them               |

## Suggested project structure

This is not the only viable project structure.\
CMake looks for .cpp files under the `src` directory and under the `test/ut` and `test/it` directories.\
In case of .hpp files, it looks under any `include` subdirectories under the above-mentioned directories.
```
.
├── .vscode
│   └── ...
├── build
│   └── ...
├── dev
│   └── ...
├── src
│   ├── main
│   │   └── main.cpp
│   └── symbols
│       ├── include
│       │   ├── letters
│       │   │   ├── A.hpp
│       │   │   └── B.hpp
│       │   ├── special
│       │   │   └── ...
│       │   └── ...
│       ├── letters
│       │   ├── A.cpp
│       │   └── B.cpp
│       ├── special
│       │   └── ...
│       └── ...
├── test
│   ├── it
│   │   ├── SymbolTests.cpp
│   │   └── ...
│   └── ut
│       ├── letters
│       │   ├── ATests.cpp
│       │   └── BTests.cpp
│       └── ...
├── .gitignore
├── CMakeLists.txt
├── LICENSE
├── README.md
└── run.sh
```
## Include directives

To add `#include` directive just specify the file path under the `include` directory.\
Examples from the above project structure:
- `#include "letters/A.hpp"`
- `#include "letters/B.hpp"`

## Google test

CMake automatically fetches the google test library and links it to the `ut` and `it` targets.\
Simply add the `#include <gtest/gtest.h>` directive to the test files.
