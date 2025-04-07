include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

CC := gcc
CFLAGS := -Os
DIET := diet
STRIP := strip

CONFIGURE_OPTS :=

ifeq ($(ARCH),x86_64)
CONFIGURE_OPTS := --host=x86_64-linux
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
DIET := diet32
CONFIGURE_OPTS := --host=i386-linux
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=arm-linux
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
CFLAGS := -static
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=mips64el-linux
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

export CC
export CFLAGS
export WITH_DIETLIBC

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	$(CP_DIR) $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && ./configure \
		--disable-nls --disable-selinux \
        --disable-shared --enable-static_link \
        CC="$(CC)" CFLAGS="$(CFLAGS)" \
		$(CONFIGURE_OPTS)
	@cd $(dir $@) && bash $(HERE)/scripts/patch_configure.sh
	@touch $@

$(WORK_DIR)/$(BIN_NAME)/$(BIN_NAME): $(WORK_DIR)/.configured
	+$(MAKE) -C $(dir $<)

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/$(BIN_NAME)/$(BIN_NAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
