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

## Auto build

If you need to build a library, you can specify it in `LIB_TO_BUILD`.

Then you need to create a rule for it, here is an example of a library that also use make:
```
LIB_TO_BUILD := lib/libxxx.so

lib/libxxx.so:
  cd lib/ && make libxxx.so
```
If you like to log what's going on you can use `@(call _special,BUILDING $@)` before the build command. `$@` is a variable containing the target's rule so `libxxx.so`. `_special` can be replaced by `_header`, `sub-header` or `build-msg`.

An example can be seen [here](https://github.com/Hazurl/Makefile/blob/master/Makefile#L103) (`sed '/s/^/\t/'` is used to offset each output message by one tabulation).

## How to use

Just copy the [Makefile](https://github.com/Hazurl/Makefile/blob/master/Makefile) in your project and set it up.
