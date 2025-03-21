include ../../../scripts/here.mk

ifndef ARCH
$(error "ARCH not defined")
endif

CFLAGS := -Os -MMD

ifeq ($(ARCH),x86_64)
CC := diet gcc
STRIP := strip
else ifeq ($(ARCH),i386)
CC := diet gcc
CFLAGS := -m32 $(CFLAGS)
STRIP := strip --strip-all
else ifeq ($(ARCH),aarch64)
CC := diet aarch64-linux-gnu-gcc
STRIP := aarch64-linux-gnu-strip --strip-all 
else ifeq ($(ARCH),mips64el)
CC := mips64el-linux-musl-gcc
CFLAGS := -march=mips64r2 -mabi=64 $(CFLAGS)
STRIP := mips64el-linux-musl-strip --strip-all
else
$(error "ARCH is invalid")
endif

SRC_DIR := $(HERE)
PROJECT_DIR := $(abspath $(HERE)/..)
BUILD_DIR := $(PROJECT_DIR)/build
DIST_DIR := $(PROJECT_DIR)/dist
TARGET_DIR := $(DIST_DIR)/$(ARCH)
WORK_DIR := $(BUILD_DIR)/$(ARCH)

BINS := $(TARGET_DIR)/vtchmod

.PHONY: all build
all: build
build: $(BINS)

$(TARGET_DIR)/vtchmod: $(WORK_DIR)/vtchmod.debug
	cp -a $< $(patsubst %.debug,%,$<)
	$(STRIP) $(patsubst %.debug,%,$<)
	mkdir -p $(dir $@)
	mv $(patsubst %.debug,%,$<) $@

$(WORK_DIR)/vtchmod.debug: $(SRC_DIR)/vtchmod.c
	mkdir -p $(dir $@)
	$(CC) -o $@ $(patsubst $(WORK_DIR)/%.debug,$(SRC_DIR)/%.c,$@)
