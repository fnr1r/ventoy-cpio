include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

ifndef TARGET
$(error TARGET is not defined)
endif

TARGET_DIR := $(DIST_DIR)/$(TARGET)
WORK_DIR := $(BUILD_DIR)/$(TARGET)

ARCH := $(TARGET)

CC := gcc
CFLAGS :=
DIET := diet
STRIP := strip

CONFIGURE_OPTS :=

ifeq ($(ARCH),x86_64)
CFLAGS := -fPIC
CONFIGURE_OPTS := --host=x86_64-linux
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
DIET := diet32
CONFIGURE_OPTS := --host=i386-linux
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
STRIP := $(CROSS_COMPILE)$(STRIP)
CFLAGS := -fPIC
CONFIGURE_OPTS := --host=arm-linux
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=mips64el-linux
else
$(error ARCH invalid)
endif

ifndef WITH_DIETLIBC
WITH_DIETLIBC := yes
endif

ifeq ($(WITH_DIETLIBC),yes)
CC := $(DIET) $(CC)
endif

SOURCES = $(shell find $(SRC_DIR))

export CC
export CFLAGS
export WITH_DIETLIBC

build: $(TARGET_DIR)/dmsetup $(TARGET_DIR)/dmsetup.debug

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	cp -ar --reflink=auto $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && $(HERE)/configure.sh $(CONFIGURE_OPTS)
	@touch $@

$(WORK_DIR)/dmsetup/dmsetup: $(WORK_DIR)/.configured
	+$(MAKE) -C $(WORK_DIR)

$(TARGET_DIR)/dmsetup.debug: $(WORK_DIR)/dmsetup/dmsetup
	@mkdir -p $(dir $@)
	cp -a --reflink=auto $< $@

$(TARGET_DIR)/dmsetup: $(TARGET_DIR)/dmsetup.debug
	@cp -a --reflink=auto $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
