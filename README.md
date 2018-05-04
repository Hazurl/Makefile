# Makefile

Can be use to compile an executable, a static library or a shared library.
See the top of the Makefile to set up it.

## Rules

X can be replace by executable, shared or static in the following rules.

`make` : build the excutable, the static library and the shared library

`make clean` : destroy the build folder

`make clean-X` : destroy the build/X folder

`make X` : make the X target

`make re` : clean then build all three targets

`make re-X` : clean then build the target

`make run` : build then run the executable

`make re-run` : clean, build then run the executable

`make valgrind` : similar to `make run` but execute it with valgrind (`valgrind $(executable_path)`)

`make re-valgrind` : similar to `make re-run` but execute it with valgrind (`valgrind $(executable_path)`)

`where-X` : output the path to the target

## How to use

Just copy the [Makefile](https://github.com/Hazurl/Makefile/blob/master/Makefile) in your project and set it up.
The minimal setup consist of [PROJECT_NAME](https://github.com/Hazurl/Makefile/blob/master/Makefile#L41), [TARGET_ALL](https://github.com/Hazurl/Makefile/blob/master/Makefile#L51), [SRC_MAINS](https://github.com/Hazurl/Makefile/blob/master/Makefile#L76) and [SRC_MAIN](https://github.com/Hazurl/Makefile/blob/master/Makefile#L78).

### Folder settings
[SRC_FOLDER](https://github.com/Hazurl/Makefile/blob/master/Makefile#L28) is the directory of your sources files (relative to the project directory).

[INC_FOLDER](https://github.com/Hazurl/Makefile/blob/master/Makefile#L29) is the directory of your header files (relative to the project directory).

> Note: You can set the same folder for both.

[BUILD_*_FOLDER](https://github.com/Hazurl/Makefile/blob/master/Makefile#L31) is just the name of the build folder. `BUILD_FOLDER` is destroy with the `make clean` command. `BUILD_X_FOLDER` is destroy with the `make clean-X` command.
> Note: If you want three directories for each target you can write `BUILD_FOLDER := executable shared static` and set each `BUILD_X_FOLDER` to their respective folder (i.e. `BUILD_STATIC_FOLDER := static`).

### General settings

[PROJECT_NAME](https://github.com/Hazurl/Makefile/blob/master/Makefile#L41) is only use for targets.

[CXX](https://github.com/Hazurl/Makefile/blob/master/Makefile#L42) is the compiler used to build and link the final executable and the shared library.

[SXX](https://github.com/Hazurl/Makefile/blob/master/Makefile#L43) is the linker used to archive the static library.

[TARGET_X](https://github.com/Hazurl/Makefile/blob/master/Makefile#L46) is the file to build.

[TARGET_ALL](https://github.com/Hazurl/Makefile/blob/master/Makefile#L51) is all the targets build when the command `make` or `make all` is executed.

### Files settings

[EXT_SRC_FILE, EXT_INC_FILE](https://github.com/Hazurl/Makefile/blob/master/Makefile#L58) are just the extension used in your project(`.cpp` and `.hpp` by default).

[header-of](https://github.com/Hazurl/Makefile/blob/master/Makefile#L71) is a function that given a source file return his header. Both the parameter and the return value or relative to `SRC_FOLDER` and `INC_FOLDER`.
`$(1:%$(EXT_SRC_FILE)=%$(EXT_INC_FILE))` will just replace the source extension by the header extension with a pattern match. ex: `folder/source.cpp` is given `%$(EXT_SRC_FILE)` is the pattern (`%$(EXT_SRC_FILE)` == `%.cpp`) so `%` will be equal to `folder/source`, the return value is `%$(EXT_INC_FILE)` so `%.hpp`, i.e. `folder/source.hpp`.
> Note: If your sources files are offset by some folders you can use `$(1:sub/folder/%$(EXT_SRC_FILE)=%$(EXT_INC_FILE))`. And `$(1:%$(EXT_SRC_FILE)=sub/folder/%$(EXT_INC_FILE))` if the headers are offset by some folders.
> Note: If the header doesn't exist for a source file, it is ignored. This function is here just to checks if the header has been modified since the last build. 

[SRC_EXCLUDE_FILE](https://github.com/Hazurl/Makefile/blob/master/Makefile#L74) will not build all source files in this list, separate them with a space.

[SRC_MAINS](https://github.com/Hazurl/Makefile/blob/master/Makefile#L76) is the list of all source file that have a `main` function. They are excluded for any build.

[SRC_MAIN](https://github.com/Hazurl/Makefile/blob/master/Makefile#L78) is the source file used for the executable only.

> Note: example of multiple main [here](https://github.com/Hazurl/Makefile/blob/master/example/Makefile#L76)

### Flags

[FLAG](https://github.com/Hazurl/Makefile/blob/master/Makefile#L84) is used for each build command.
[STATIC_LINK_FLAG](https://github.com/Hazurl/Makefile/blob/master/Makefile#L85) is used with `SXX`.

[INC_FLAG](https://github.com/Hazurl/Makefile/blob/master/Makefile#L89) is used to specify different path to headers file, by default `-I $(INC_FOLDER)`. `-I` must be before each path. This argument affect the directive `#include <...>`.

### LIBRARY

[LIBS_PATH](https://github.com/Hazurl/Makefile/blob/master/Makefile#L97) is used by the linker to search libraries. `-L` must be before each path. 
> Note: example [here](https://github.com/Hazurl/Makefile/blob/master/example/Makefile#L97)

[LIBS](https://github.com/Hazurl/Makefile/blob/master/Makefile#L100) are all the libraries to link with the targets.
> Note: `-lxyz` will search for `libxyz.so` or `libxyz.a` in the default system path and the paths in `LIBS_PATH`
> Note: example [here](https://github.com/Hazurl/Makefile/blob/master/example/Makefile#L100)

[LIB_TO_BUILD](https://github.com/Hazurl/Makefile/blob/master/Makefile#L103) is used to specify all libraries to build.
You need to create a rule for all of them, here is an example of a library that also use make:
```
LIB_TO_BUILD := lib/libxyz.so

lib/libxyz.so:
  cd lib/ && make libxyz.so
```
If you like to log what's going on you can use `@$(call _special,BUILDING $@)` before the build command. `$@` is a variable containing the target's rule so `libxxx.so`. `_special` can be replaced by `_header`, `_sub-header` or `_build-msg`.

> Note: example [here](https://github.com/Hazurl/Makefile/blob/master/example/Makefile#L106) (`sed '/s/^/\t/'` is used to offset each output message by one tabulation).
