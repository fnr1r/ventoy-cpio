include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

CC := gcc
CFLAGS := -Os
DIET := diet
LDFLAGS := -static
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
$(error ARCH is invalid)
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
export LDFLAGS

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	$(CP_DIR) $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/programs/$(NAME): $(WORK_DIR)/.copied
	+$(MAKE) -C $(dir $<) BUILD_SHARED=no

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/programs/$(NAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
