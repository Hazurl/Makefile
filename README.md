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
