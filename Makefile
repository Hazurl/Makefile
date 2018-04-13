# Structure of the project: 
#
# 	/
#   	build/  
#			shared/
#				project-name.so
#				src/
#					object files...
#			static/
#				project-name.a
#				src/
#					object files...
#			executable/
#				project-name
#				src/
#					object files
#		src/
#			sources files...
#		inc/
#			header files...

#####
##### FOLDER SETTINGS
#####

SRC_FOLDER := src
INC_FOLDER := inc

BUILD_FOLDER := build

BUILD_SHARED_FOLDER := $(BUILD_FOLDER)/shared
BUILD_STATIC_FOLDER := $(BUILD_FOLDER)/static
BUILD_EXE_FOLDER := $(BUILD_FOLDER)/executable

#####
##### GENERAL SETTINGS
#####

PROJECT_NAME := placeholder
CXX := g++

# Targets
TARGET_SHARED := $(BUILD_SHARED_FOLDER)/lib$(PROJECT_NAME).so
TARGET_STATIC := $(BUILD_STATIC_FOLDER)/lib$(PROJECT_NAME).a
TARGET_EXE := $(BUILD_EXE_FOLDER)/$(PROJECT_NAME)

#####
##### FILES SETTINGS
#####

# Extension
EXT_SRC_FILE = .cpp
EXT_INC_FILE = .hpp

# Get header from source file
# This function is only used to checks if the header has bee modified and the object file must be rebuild
# So if the header doesn't exist it's ok

# The first argument is the source file relative to $(SRC_FOLDER)
# The header must be relative to $(INC_FOLDER)

# EX: $(1:%$(EXT_SRC_FILE)=%$(EXT_INC_FILE)) 
# will take the file "folder/sub_folder_file.cpp"
# and transform it into "folder/sub_folder_file.hpp"
header-of = $(1:%$(EXT_SRC_FILE)=%$(EXT_INC_FILE))

# Relative to $(SRC_FOLDER)
SRC_EXCLUDE_FILE := 
# All files that are not use for libraries, don't add src/
SRC_MAINS := main.cpp another_main.cpp
# The main file to use (must be in $(SRC_MAINS))
SRC_MAIN := main.cpp

#####
##### FLAGS
#####

FLAGS := -std=c++17 -g3 -Wall -Wextra -Wno-pmf-conversions -O2
# Include path
# Must be use with -I
INC_FLAG := -I $(INC_FOLDER)

#####
##### LIBRARY
#####

# Path to libaries if not in $PATH, for example (relative to the project folder): lib/
# Must be use with -L
LIBS_PATH :=

# For example: -lsfml-graphics
LIBS :=

###############################################
#                   PRIVATE                   #
###############################################

#####
##### OTHER
#####

_RESET := \033[0m
_BOLD := \033[1m

_COLOR_RED := \033[31m
_COLOR_GREEN := \033[32m
_COLOR_YELLOW := \033[33m
_COLOR_BLUE := \033[34m
_COLOR_MAGENTA := \033[35m
_COLOR_CYAN := \033[36m
_COLOR_WHITE := \033[37m

SHARED_FLAGS := -fPIC

MAKEFLAGS += --no-print-directory

#####
##### FUNCTIONS
#####

_void =
_space = $(_void) $(_void)
_comma = ,

# join <between> <list>
_join = $(subst $(_space),$(1),$(2))

# err <message>
err = $(shell echo -e "$(_COLOR_RED)$(1)$(_RESET)")

# _header <message>
_header = echo -e "$(_COLOR_CYAN)$(_BOLD)>>> $(1)$(_RESET)"
# _sub-header <message>
_sub-header = echo -e "$(_COLOR_GREEN)>>> $(1)$(_RESET)"
# _build-msg <target> <from>
_build-msg = echo -e "$(_COLOR_WHITE):: Building $(_BOLD)$(1)$(_RESET)$(_COLOR_WHITE) from $(_BOLD)$(2)$(_RESET)"

# not <value>
# return an empty string if value is not
not = $(if $(1),,not-empty-string)

# _remove-folder <folder>
define _remove-folder
	rm -rf $(1)
endef

# _is-empty <value> [<message>]
# example: $(call check-not-empty,FOLDER,The folder must be specified)
_is-empty = $(call not,$(1))
define _is-empty-er
	$(if $(call _is-empty,$(1)),$(error Value is empty $(if $(2),($(2)) )))
endef

# _exists <file> [<message>]
_exists = $(wildcard $(1))
define _exists-er
	$(if $(call _exists,$(1)),,$(error File '$(1)' doesn't exists $(if $(2),($(2)) )))
endef

#####
##### SOURCES
#####

_SRC_MAINS := $(addprefix src/,$(SRC_MAINS))
# All sources files not main
_SRC_FILES := $(filter-out $(_SRC_MAINS),$(shell find $(SRC_FOLDER) -name '*$(EXT_SRC_FILE)'))

#####
##### DIRECTORIES
#####

# All sources file directories
_SRC_DIR := $(sort $(dir $(_SRC_FILES)))

_EXE_DIR := $(addprefix $(BUILD_EXE_FOLDER)/,$(_SRC_DIR))
_SHARED_DIR := $(addprefix $(BUILD_SHARED_FOLDER)/,$(_SRC_DIR))
_STATIC_DIR := $(addprefix $(BUILD_STATIC_FOLDER)/,$(_SRC_DIR))

_BUILD_DIR := $(_EXE_DIR) $(_SHARED_DIR) $(_STATIC_DIR)

#####
##### OBJECT FILES
##### 

_OBJ_MAIN := $(SRC_MAIN:%$(EXT_SRC_FILE)=$(BUILD_EXE_FOLDER)/$(SRC_FOLDER)/%.o)
_OBJ_SRC_EXE := $(_OBJ_MAIN) $(_SRC_FILES:%$(EXT_SRC_FILE)=$(BUILD_EXE_FOLDER)/%.o) 

_OBJ_SRC_SHARED := $(_SRC_FILES:%$(EXT_SRC_FILE)=$(BUILD_SHARED_FOLDER)/%.o)

_OBJ_SRC_STATIC := $(_SRC_FILES:%$(EXT_SRC_FILE)=$(BUILD_STATIC_FOLDER)/%.o)

#####
##### VERIFICATION
##### 

$(call _is-empty-er,$(call not,$(filter-out $(SRC_MAINS),$(SRC_MAIN))),$(SRC_MAIN) is not in the main's list)
$(call _exists-er,$(SRC_FOLDER)/$(SRC_MAIN),$(SRC_FOLDER)/$(SRC_MAIN) doesn't exists)

#####
##### RULES
#####

.PHONY: all clean executable shared static

all: 
	@make executable
	@make shared
	@make static

executable: 
	@$(call _header,BUILDING EXECUTABLE...)
	@make $(TARGET_EXE)

shared:
	@$(call _header,BUILDING SHARED LIBRARY...)
	@make $(TARGET_SHARED)

static:
	@$(call _header,BUILDING STATIC LIBRARY...)
	@make $(TARGET_STATIC)

clean:
	@$(call _remove-folder,$(BUILD_FOLDER))

clean-executable:
	@$(call _remove-folder,$(BUILD_EXE_FOLDER))

clean-shared:
	@$(call _remove-folder,$(BUILD_SHARED_FOLDER))

clean-static:
	@$(call _remove-folder,$(BUILD_STATIC_FOLDER))

re:
	@make clean
	@make

re-executable:
	@make clean-executable
	@make executable

re-shared:
	@make clean-shared
	@make shared

re-static:
	@make clean-static
	@make static

run:
	@make executable
	@echo
	@$(call _sub-header,EXECUTING $(TARGET_EXE)...)
	@$(TARGET_EXE)
	@$(call _sub-header,PROGRAM HALT WITH CODE $$?)

re-run:
	@make re-executable
	@make run

$(_BUILD_DIR):
	@mkdir -p $(_BUILD_DIR)

###


$(TARGET_STATIC): $(_BUILD_DIR) $(_OBJ_SRC_STATIC)
	@$(call _sub-header,Archiving...)
	@ar rcs $(TARGET_STATIC) $(_OBJ_SRC_STATIC)
	@$(call _header,Static library done ($(TARGET_STATIC)))

$(BUILD_STATIC_FOLDER)/$(SRC_FOLDER)/%.o: $(SRC_FOLDER)/%$(EXT_SRC_FILE) $(INC_FOLDER)/$(call header-of,%$(EXT_SRC_FILE))
	@$(call _build-msg,$(notdir $@),$(call _join,$(_comma)$(_space),$(strip $(notdir $< $(wildcard $(word 2,$^))))))
	@g++ -c $(INC_FLAG) $(FLAGS) -o "$@" "$<"


###


$(TARGET_SHARED): $(_BUILD_DIR) $(_OBJ_SRC_SHARED)
	@$(call _sub-header,Shared library creation...)
	@g++ $(INC_FLAG) $(FLAGS) -shared -o $(TARGET_SHARED) $(_OBJ_SRC_SHARED) $(LIBS_PATH) $(LIBS)
	@$(call _header,Shared library done ($(TARGET_SHARED)))

$(BUILD_SHARED_FOLDER)/$(SRC_FOLDER)/%.o: $(SRC_FOLDER)/%$(EXT_SRC_FILE) $(INC_FOLDER)/$(call header-of,%$(EXT_SRC_FILE))
	@$(call _build-msg,$(notdir $@),$(call _join,$(_comma)$(_space),$(strip $(notdir $< $(wildcard $(word 2,$^))))))
	@g++ -c $(INC_FLAG) $(FLAGS) $(SHARED_FLAGS) -o "$@" "$<"


###


$(TARGET_EXE): $(_BUILD_DIR) $(_OBJ_SRC_EXE)
	@$(call _sub-header,Linking...)
	@g++ $(INC_FLAG) $(FLAGS) $(_OBJ_SRC_EXE) -o "$@" $(LIBS_PATH) $(LIBS)
	@$(call _header,Executable done ($(TARGET_EXE)))

$(BUILD_EXE_FOLDER)/$(SRC_FOLDER)/%.o: $(SRC_FOLDER)/%$(EXT_SRC_FILE) $(INC_FOLDER)/$(call header-of,%$(EXT_SRC_FILE))
	@$(call _build-msg,$(notdir $@),$(call _join,$(_comma)$(_space),$(strip $(notdir $< $(wildcard $(word 2,$^))))))
	@g++ -c $(INC_FLAG) $(FLAGS) -o "$@" "$<"


# Just to avoid file without headers
%$(EXT_INC_FILE):
	