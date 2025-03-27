include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

TARGET_DIR := $(DIST_DIR)/$(TARGET)
WORK_DIR := $(BUILD_DIR)/$(TARGET)

ARCH := $(TARGET)

CC := gcc
CFLAGS := -Os -pedantic -Wall -Wextra
CPPFLAGS := -DXZ_DEC_ANY_CHECK -DXZ_DEC_CONCATENATED -DXZ_USE_CRC64
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

SHARED_SRCS := xz_crc32.c xz_crc64.c xz_dec_stream.c xz_dec_lzma2.c xz_dec_bcj.c
SHARED_OBJS := $(SHARED_SRCS:.c=.o)
XZ_HEADERS = xz.h xz_private.h xz_stream.h xz_lzma2.h xz_config.h
ALL_CPPFLAGS = -Isrc/linux/include/linux -Isrc/userspace $(CPPFLAGS)

VPATH := $(SRC_DIR)/userspace $(SRC_DIR)/linux/lib/xz
vpath %.o $(WORK_DIR)

build: $(TARGET_DIR)/xzminidec $(TARGET_DIR)/xzminidec.debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)
clean-all:
	-rm -r $(DIST_DIR) $(BUILD_DIR)

$(WORK_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(ALL_CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(TARGET_DIR)/xzminidec.debug: $(foreach o,$(SHARED_OBJS),$(WORK_DIR)/$o) $(WORK_DIR)/xzminidec.o
	@mkdir -p $(dir $@)
	$(CC) -o $@ $(COMMON_OBJS) $^

$(TARGET_DIR)/xzminidec: $(TARGET_DIR)/xzminidec.debug
	@cp -a --reflink=auto $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
