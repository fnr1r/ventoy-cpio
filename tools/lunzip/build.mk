include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

CC := gcc
CFLAGS := -Os
CPPFLAGS := -Wall -W
DIET := diet
LDFLAGS := -static
STRIP := strip

ifeq ($(ARCH),x86_64)
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
WITH_DIETLIBC := no
else
$(error ARCH is invalid)
endif

ifndef WITH_DIETLIBC
WITH_DIETLIBC := yes
endif

ifeq ($(WITH_DIETLIBC),yes)
CC := $(DIET) $(CC)
endif

SOURCES = $(shell find $(SRC_DIR))

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	$(CP_DIR) $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && ./configure --disable-nls \
        CC="$(CC)" CFLAGS="$(CFLAGS)" CPPFLAGS="$(CPPFLAGS)" LDFLAGS="$(LDFLAGS)"
	@touch $@

$(WORK_DIR)/$(BIN_NAME): $(WORK_DIR)/.configured
	+$(MAKE) -C $(dir $@)

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/$(BIN_NAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
