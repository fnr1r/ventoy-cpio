include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

WORK_DIR := $(BUILD_DIR)/$(TARGET)

ARCH := $(call get_arch,$(TARGET))
BIN_NAME := $(call get_bin,$(TARGET))

CONFIGS_DIR := $(HERE)/configs

CC := gcc
CFLAGS := -Os

ifeq ($(ARCH),x86_64)
CC := musl-gcc
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CONFIG_ASH := 04-ash-internal-glob.config
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
CONFIG_ASH := 02-ash-only.config
else
$(error ARCH invalid)
endif

CONFIG_FILENAME := $(CONFIG_$(call uppercase,$(BIN_NAME)))
SOURCES = $(shell find $(SRC_DIR))

ifdef CROSS_COMPILE
export CROSS_COMPILE
endif
export CC
export CFLAGS

TARGET_BINS := $(DIST_DIR)/$(ARCH)-$(BIN_NAME) $(DIST_DIR)/$(ARCH)/$(BIN_NAME)

build: $(TARGET_BINS)
clean:
	-rm -r $(TARGET_BINS) $(WORK_DIR)

$(WORK_DIR)/.config: $(CONFIGS_DIR)/$(CONFIG_FILENAME)
	@mkdir -p $(dir $@)
	cp -a $< $@

$(WORK_DIR)/busybox: $(SRC_FILENAME) $(SOURCES) $(WORK_DIR)/.config
	+$(MAKE) -C $(WORK_DIR) KBUILD_SRC=$(HERE)/$(SRC_DIR) -f $(HERE)/$(SRC_DIR)/Makefile

$(DIST_DIR)/$(ARCH)-$(BIN_NAME): $(WORK_DIR)/busybox
	@mkdir -p $(dir $@)
	cp -a $< $@

$(DIST_DIR)/$(ARCH)/$(BIN_NAME): $(DIST_DIR)/$(ARCH)-$(BIN_NAME)
	@mkdir -p $(dir $@)
	ln -s ../$(notdir $<) $@
