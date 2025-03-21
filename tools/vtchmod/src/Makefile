include ../../../scripts/here.mk

ifndef ARCH
$(error "ARCH not defined")
endif

CFLAGS := -Os -static
DIET := diet
DIETFLAGS :=
STRIPFLAGS :=

ifeq ($(ARCH),x86_64)
CC := gcc
STRIP := strip
STRIPFLAGS := --strip-all
else ifeq ($(ARCH),i386)
CC := gcc
CFLAGS := -m32 $(CFLAGS)
DIET := /opt/diet32/bin/diet
STRIP := strip
else ifeq ($(ARCH),aarch64)
CC := aarch64-linux-gnu-gcc
STRIP := aarch64-linux-gnu-strip
STRIPFLAGS := --strip-all
else ifeq ($(ARCH),mips64el)
CC := mips64el-linux-musl-gcc
CFLAGS := -march=mips64r2 -mabi=64 $(CFLAGS)
STRIP := mips64el-linux-musl-strip
STRIPFLAGS := --strip-all
else
$(error "ARCH is invalid")
endif

ifndef WITH_DIET
WITH_DIET := yes
endif

ifeq ($(WITH_DIET),yes)
CC := $(DIET) $(DIETFLAGS) $(CC)
endif

SRC_DIR := $(HERE)
PROJECT_DIR := $(abspath $(HERE)/..)
BUILD_DIR := $(PROJECT_DIR)/build
DIST_DIR := $(PROJECT_DIR)/dist
TARGET_DIR := $(DIST_DIR)/$(ARCH)
WORK_DIR := $(BUILD_DIR)/$(ARCH)

BINS := $(WORK_DIR)/vtchmod.debug $(TARGET_DIR)/vtchmod

.PHONY: all build
all: build
build: $(BINS)

$(TARGET_DIR)/%: $(WORK_DIR)/%.debug
	cp -a $< $(patsubst %.debug,%,$<)
	$(STRIP) $(STRIPFLAGS) $(patsubst %.debug,%,$<)
	mkdir -p $(dir $@)
	mv $(patsubst %.debug,%,$<) $@

$(WORK_DIR)/%.debug: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $(patsubst $(WORK_DIR)/%.debug,$(SRC_DIR)/%.c,$@)
