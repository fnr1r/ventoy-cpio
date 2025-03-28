include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

ARCH := $(call get_arch,$(TARGET))
BIN_NAME := $(call get_bin,$(TARGET))

TARGET_DIR := $(DIST_DIR)/$(ARCH)

CONFIGS_DIR := configs

CC := gcc
CFLAGS := -Os
DIET := diet

ifeq ($(ARCH),x86_64)
CC := musl-$(CC)
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
DIET := diet32
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
CONFIG_ASH := 04-ash-internal-glob.config
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
CONFIG_ASH := 02-ash-only.config
else
$(error ARCH is invalid)
endif

ifndef WITH_DIETLIBC
WITH_DIETLIBC := no
endif

ifeq ($(WITH_DIETLIBC),yes)
CC := $(DIET) $(CC)
endif

CONFIG_FILENAME := $(CONFIG_$(call uppercase,$(BIN_NAME)))
SOURCES = $(shell find $(SRC_DIR) | grep -v $(SRC_DIR) | grep -v $(SRC_DIR)/.kernelrelease)

TARGET_BINS := $(DIST_DIR)/$(ARCH)-$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME)

build: $(TARGET_BINS)
clean:
	-rm -r $(TARGET_BINS) $(WORK_DIR)

$(WORK_DIR)/.config: $(CONFIGS_DIR)/$(CONFIG_FILENAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(WORK_DIR)/busybox: $(SRC_FILENAME) $(SOURCES) $(WORK_DIR)/.config
	+$(MAKE) -C $(WORK_DIR) KBUILD_SRC=$(HERE)/$(SRC_DIR) -f $(HERE)/$(SRC_DIR)/Makefile \
		CC="$(CC)" CFLAGS="$(CFLAGS)" $(if $(CROSS_COMPILE),CROSS_COMPILE=$(CROSS_COMPILE),)

$(DIST_DIR)/$(ARCH)-$(BIN_NAME): $(WORK_DIR)/busybox
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(DIST_DIR)/$(ARCH)-$(BIN_NAME)
	@mkdir -p $(dir $@)
	ln -s ../$(notdir $<) $@
