include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

CC := gcc
CFLAGS := -Os
DIET := diet
STRIP := strip

# broken too :(
#CFLAGS += -static
#DEVMAPPER_STATIC_CFLAGS := -L/build/tools/device-mapper/build/$(ARCH)/lib
#export DEVMAPPER_STATIC_CFLAGS

CONFIGURE_OPTS :=

ifeq ($(ARCH),x86_64)
CC := $(CC)
CONFIGURE_OPTS := --host=x86_64-linux
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
DIET := diet32
CONFIGURE_OPTS := --host=i386-linux
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
export WITH_DIETLIBC
unexport TARGETS

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	$(CP_DIR) $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && ./configure \
		--disable-shared --enable-static \
        CC="$(CC)" CFLAGS="$(CFLAGS)" \
		$(CONFIGURE_OPTS)
	@touch $@

$(WORK_DIR)/src/veritysetup: $(WORK_DIR)/.configured
	+$(MAKE) -C $(WORK_DIR)/lib
	+$(MAKE) -C $(WORK_DIR)/src $(notdir $@)

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/src/veritysetup
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
