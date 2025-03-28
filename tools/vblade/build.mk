include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

TARGET_DIR := $(DIST_DIR)/$(TARGET)
WORK_DIR := $(BUILD_DIR)/$(TARGET)

ARCH := $(TARGET)

CC := gcc
CFLAGS := -Os -Wall -static
DIET := diet
STRIP := strip

ifeq ($(ARCH),x86_64)
CC := musl-$(CC)
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
DIET := diet32
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
STRIP := $(CROSS_COMPILE)$(STRIP)
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
STRIP := $(CROSS_COMPILE)$(STRIP)
else
$(error ARCH invalid)
endif

ifndef WITH_DIETLIBC
WITH_DIETLIBC := no
endif

ifeq ($(WITH_DIETLIBC),yes)
CC := $(DIET) $(CC)
endif

SOURCES = $(shell find $(SRC_DIR))

export CC
export CFLAGS

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	cp -ar --reflink=auto $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/$(BIN_NAME): $(WORK_DIR)/.copied
	+$(MAKE) -C $(WORK_DIR) CC="$(CC)" CFLAGS="$(CFLAGS)"

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/$(BIN_NAME)
	@mkdir -p $(dir $@)
	cp -a --reflink=auto $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@cp -a --reflink=auto $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
