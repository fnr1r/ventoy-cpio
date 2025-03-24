include ../../../scripts/here.mk

ifndef ARCH
$(error "ARCH not defined")
endif

CFLAGS := -Os -static -Wall -D_FILE_OFFSET_BITS=64 -DBUILD_VTOY_TOOL
DIET := diet
DIETFLAGS := -v
STRIPFLAGS :=

ifeq ($(ARCH),x86_64)
CC := gcc
CFLAGS := $(CFLAGS) -DVTOY_X86_64
STRIP := strip
STRIPFLAGS := --strip-all
WITH_DIET := no
else ifeq ($(ARCH),i386)
CC := gcc
CFLAGS := -m32 $(CFLAGS) -DVTOY_I386
DIET := /opt/diet32/bin/diet
STRIP := strip
else ifeq ($(ARCH),aarch64)
CC := aarch64-linux-gcc
CFLAGS := $(CFLAGS) -DVTOY_AA64
STRIP := aarch64-linux-strip
STRIPFLAGS := --strip-all
else ifeq ($(ARCH),mips64el)
CC := mips64el-linux-musl-gcc
CFLAGS := -march=mips64r2 -mabi=64 $(CFLAGS) -DVTOY_MIPS64
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
CFLAGS := $(CFLAGS) -DUSE_DIET_C
endif

SRC_DIR := $(HERE)
PROJECT_DIR := $(abspath $(HERE)/..)
BUILD_DIR := $(PROJECT_DIR)/build
DIST_DIR := $(PROJECT_DIR)/dist
TARGET_DIR := $(DIST_DIR)/$(ARCH)
WORK_DIR := $(BUILD_DIR)/$(ARCH)

CFLAGS := $(CFLAGS) -I$(SRC_DIR)/BabyISO

BINS := $(WORK_DIR)/vtoytool.debug $(TARGET_DIR)/vtoytool
SOURCE_FILES := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/BabyISO/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(WORK_DIR)/%.o,$(SOURCE_FILES))

.PHONY: all build
all: build
build: $(OBJS) $(BINS)

$(TARGET_DIR)/%: $(WORK_DIR)/%.debug
	cp -a $< $(patsubst %.debug,%,$<)
	$(STRIP) $(STRIPFLAGS) $(patsubst %.debug,%,$<)
	mkdir -p $(dir $@)
	mv $(patsubst %.debug,%,$<) $@

$(WORK_DIR)/%.debug: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

$(WORK_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ -c $<
