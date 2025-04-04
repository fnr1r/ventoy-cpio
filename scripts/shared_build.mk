ifndef SCRIPTS_DIR
$(error SCRIPTS_DIR not set)
endif
include $(SCRIPTS_DIR)/shared.mk

ifndef TARGET
$(error TARGET is not defined)
endif

.PHONY: all build clean
all: build
build:
clean:

BUILD_DIR := build
DIST_DIR := dist

split_binname = $(subst /, ,$(subst -, ,$(patsubst dist/%,%,$1)))
get_arch = $(firstword $(call split_binname,$1))
get_bin = $(lastword $(call split_binname,$1))

WORK_DIR := $(BUILD_DIR)/$(TARGET)

ARCH := $(call get_arch,$(TARGET))
BIN_NAME := $(call get_bin,$(TARGET))

TARGET_DIR := $(DIST_DIR)/$(ARCH)
