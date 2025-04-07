include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

export GZIP_SUPPORT
export XZ_SUPPORT
export LZO_SUPPORT
export LZ4_SUPPORT
export ZSTD_SUPPORT
export LZMA_XZ_SUPPORT

PREFIX_DIR := $(WORK_DIR)/prefix

CC := gcc
CFLAGS := -Os
DIET := diet
LDFLAGS := -static
STRIP := strip

CONFIGURE_OPTS :=

ifeq ($(ARCH),x86_64)
CC := musl-$(CC)
CONFIGURE_OPTS := --host=x86_64-linux
else ifeq ($(ARCH),i386)
CC := musl-i386-$(CC) -m32 -Wl,-melf_i386
DIET := diet32
CONFIGURE_OPTS := --host=i386-linux
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
CFLAGS := $(CFLAGS) -D_VTOY_DEF_UINTS
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=arm-linux
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
STRIP := $(CROSS_COMPILE)$(STRIP)
CONFIGURE_OPTS := --host=mips64el-linux
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

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/.copied: $(SOURCES)
	@mkdir -p $(dir $@)
	$(CP_DIR) $(SRC_DIR)/. $(dir $@)
	@touch $@

$(WORK_DIR)/$(ZLIB_NAME)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && CFLAGS="$(CFLAGS)" ./configure --prefix=../prefix --static
	@touch $@

$(WORK_DIR)/$(ZLIB_NAME)/$(ZLIB_TARGET): $(WORK_DIR)/$(ZLIB_NAME)/.configured
	+$(MAKE) -C $(dir $<) $(notdir $@)

$(PREFIX_DIR)/lib/$(ZLIB_TARGET): $(WORK_DIR)/$(ZLIB_NAME)/$(ZLIB_TARGET)
	+$(MAKE) -C $(dir $<) install

$(WORK_DIR)/$(XZ_NAME)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && ./configure \
		--prefix=$(HERE)/$(PREFIX_DIR) \
		--enable-shared=no --enable-static=yes \
		--disable-xz --disable-xzdec \
		--disable-lzmadec --disable-lzmainfo --disable-lzma-links \
		--disable-scripts \
		--disable-assembler \
		$(CONFIGURE_OPTS) \
		CC="$(CC)" CFLAGS="$(CFLAGS)"
	@touch $@

$(WORK_DIR)/$(XZ_NAME)/src/liblzma/.libs/$(XZ_TARGET): $(WORK_DIR)/$(XZ_NAME)/.configured
	+$(MAKE) -C $(dir $<)

$(PREFIX_DIR)/lib/$(XZ_TARGET): $(WORK_DIR)/$(XZ_NAME)/src/liblzma/.libs/$(XZ_TARGET)
	+$(MAKE) -C $(WORK_DIR)/$(XZ_NAME) install

$(WORK_DIR)/$(LZO_NAME)/.configured: $(WORK_DIR)/.copied
	cd $(dir $@) && ./configure \
		--prefix=$(HERE)/$(PREFIX_DIR) \
		$(CONFIGURE_OPTS) \
		CC="$(CC)" CFLAGS="$(CFLAGS)"
	@touch $@

$(WORK_DIR)/$(LZO_NAME)/src/.libs/$(LZO_TARGET): $(WORK_DIR)/$(LZO_NAME)/.configured
	+$(MAKE) -C $(dir $<)

$(PREFIX_DIR)/lib/$(LZO_TARGET): $(WORK_DIR)/$(LZO_NAME)/src/.libs/$(LZO_TARGET)
	+$(MAKE) -C $(WORK_DIR)/$(LZO_NAME) install

$(WORK_DIR)/$(LZ4_NAME)/lib/$(LZ4_TARGET): $(WORK_DIR)/.copied
	+$(MAKE) -C $(dir $@) BUILD_SHARED=no CFLAGS="$(CFLAGS)"

$(PREFIX_DIR)/lib/$(LZ4_TARGET): $(WORK_DIR)/$(LZ4_NAME)/lib/$(LZ4_TARGET)
	+$(MAKE) -C $(dir $<) BUILD_SHARED=no CFLAGS="$(CFLAGS)" PREFIX=../../prefix install

$(WORK_DIR)/$(ZSTD_NAME)/lib/$(ZSTD_TARGET): $(WORK_DIR)/.copied
	+$(MAKE) -C $(dir $@) CFLAGS="$(CFLAGS)" PREFIX=../../prefix \
		$(notdir $@)

$(PREFIX_DIR)/lib/$(ZSTD_TARGET): $(WORK_DIR)/$(ZSTD_NAME)/lib/$(ZSTD_TARGET)
	+$(MAKE) -C $(dir $<) CFLAGS="$(CFLAGS)" PREFIX=../../prefix \
		install-static install-includes

LIBRARIES := $(ZLIB_TARGET) $(XZ_TARGET) $(LZO_TARGET) $(LZ4_TARGET) $(ZSTD_TARGET)
LIBRARY_PATHS := $(foreach a,$(LIBRARIES),$(PREFIX_DIR)/lib/$a)

$(WORK_DIR)/squashfs-tools/$(BIN_NAME): $(WORK_DIR)/.copied $(LIBRARY_PATHS)
	+CFLAGS="$(CFLAGS) -I../prefix/include" \
		LDFLAGS="$(LDFLAGS) -L../prefix/lib" \
		$(MAKE) -C $(dir $@) $(notdir $@)

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/squashfs-tools/$(BIN_NAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
