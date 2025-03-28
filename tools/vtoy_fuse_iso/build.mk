include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

PREFIX_DIR := $(WORK_DIR)/prefix

ARCH := $(TARGET)

CC := gcc
CFLAGS := -Os
DIET := diet
STRIP := strip

CONFIGURE_OPTS :=

ifeq ($(ARCH),x86_64)
CC := musl-$(CC)
CONFIGURE_OPTS := --host=x86_64-linux-musl
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
DIET := diet32
CONFIGURE_OPTS := --host=i386-linux-gnu
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=aarch64-linux-uclibc
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=mips64el-linux-musl
else
$(error ARCH is invalid)
endif

ifndef WITH_DIETLIBC
WITH_DIETLIBC := no
endif

ifeq ($(WITH_DIETLIBC),yes)
CC := $(DIET) $(CC)
endif

FUSE_SOURCES = $(shell find $(FUSE_DIR))

export CC
export CFLAGS

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/libfuse/.copied: $(FUSE_SOURCES)
	@mkdir -p $(dir $@)
	$(CP_DIR) $(FUSE_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/libfuse/.configured: $(WORK_DIR)/libfuse/.copied
	cd $(dir $@) && ./configure --prefix="$(HERE)/$(PREFIX_DIR)" \
        --enable-lib --enable-static=yes --enable-shared=no \
        --enable-util=no --enable-example=no \
		$(CONFIGURE_OPTS)
	@if [ "$(ARCH)" = "aarch64" ]; then \
		cd $(dir $@) \
		sed '/#define *__u64/d'  -i include/fuse_kernel.h; \
    	sed '/#define *__s64/d'  -i include/fuse_kernel.h; \
    	sed 's/__u64/uint64_t/g' -i include/fuse_kernel.h; \
    	sed 's/__s64/int64_t/g'  -i include/fuse_kernel.h; \
	fi
	@touch $@

$(WORK_DIR)/libfuse/lib/.libs/$(FUSE_TARGET): $(WORK_DIR)/libfuse/.configured
	+$(MAKE) -C $(dir $<) CC="$(CC)" CFLAGS="$(CFLAGS)"

$(PREFIX_DIR)/lib/$(FUSE_TARGET): $(WORK_DIR)/libfuse/lib/.libs/$(FUSE_TARGET)
	+$(MAKE) -C $(WORK_DIR)/libfuse CC="$(CC)" CFLAGS="$(CFLAGS)" install

$(WORK_DIR)/$(BIN_NAME): $(PREFIX_DIR)/lib/$(FUSE_TARGET)
	$(CC) $(CFLAGS) -static -D_FILE_OFFSET_BITS=64 \
		"-I$(PREFIX_DIR)/include" "-L$(PREFIX_DIR)/lib" \
		-lfuse "$<" $(wildcard $(WORK_DIR)/libfuse/lib/*.o) \
		-o $@ $(SRC_DIR)/$(BIN_NAME).c

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/$(BIN_NAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
