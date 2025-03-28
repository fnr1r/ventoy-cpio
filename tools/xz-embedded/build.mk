include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

TARGET_DIR := $(DIST_DIR)/$(TARGET)
WORK_DIR := $(BUILD_DIR)/$(TARGET)

ARCH := $(TARGET)

CC := gcc
CFLAGS := -Os -pedantic
CPPFLAGS := -Wall -Wextra -DXZ_DEC_ANY_CHECK -DXZ_DEC_CONCATENATED -DXZ_USE_CRC64
LDFLAGS := -static
DIET := diet
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

CPPFLAGS := $(CPPFLAGS) -I$(SRC_DIR)/linux/include/linux -I$(SRC_DIR)/userspace

SHARED_SRCS := xz_crc32.c xz_crc64.c xz_dec_stream.c xz_dec_lzma2.c xz_dec_bcj.c
SHARED_OBJS := $(SHARED_SRCS:.c=.o)
XZ_HEADERS = xz.h xz_private.h xz_stream.h xz_lzma2.h xz_config.h

vpath %.c $(SRC_DIR)/userspace $(SRC_DIR)/linux/lib/xz

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(TARGET_DIR)/$(BIN_NAME).debug: $(foreach o,$(SHARED_OBJS),$(WORK_DIR)/$o) $(WORK_DIR)/$(BIN_NAME).o
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $^

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
