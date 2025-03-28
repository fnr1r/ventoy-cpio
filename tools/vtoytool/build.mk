include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include $(SCRIPTS_DIR)/shared_build.mk
include info.mk

ARCH := $(TARGET)

CC := gcc
CFLAGS := -Os
CPPFLAGS := -D_FILE_OFFSET_BITS=64 -DBUILD_VTOY_TOOL
LDFLAGS := -static
DIET := diet
STRIP := strip

ifeq ($(ARCH),x86_64)
CC := musl-$(CC)
CPPFLAGS := $(CPPFLAGS) -DVTOY_X86_64
WITH_DIETLIBC := no
# flag also needed for musl
CPPFLAGS := $(CPPFLAGS) -DUSE_DIET_C
else ifeq ($(ARCH),i386)
CC := $(CC) -m32
CPPFLAGS := $(CPPFLAGS) -DVTOY_I386
DIET := diet32
else ifeq ($(ARCH),aarch64)
CROSS_COMPILE := aarch64-linux-
CC := $(CROSS_COMPILE)$(CC)
CPPFLAGS := $(CPPFLAGS) -DVTOY_AA64
STRIP := $(CROSS_COMPILE)$(STRIP)
else ifeq ($(ARCH),mips64el)
CROSS_COMPILE := mips64el-linux-musl-
CC := $(CROSS_COMPILE)$(CC) -march=mips64r2 -mabi=64
CPPFLAGS := $(CPPFLAGS) -DVTOY_MIPS64
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
CPPFLAGS := $(CPPFLAGS) -DUSE_DIET_C
endif

CPPFLAGS := $(CPPFLAGS) -I$(SRC_DIR)/BabyISO

SOURCES := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/BabyISO/*.c)
OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(WORK_DIR)/%.o,$(SOURCES))

build: $(TARGET_DIR)/$(BIN_NAME) $(TARGET_DIR)/$(BIN_NAME).debug
clean:
	-rm -r $(TARGET_DIR) $(WORK_DIR)

$(WORK_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

$(WORK_DIR)/$(BIN_NAME): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

$(TARGET_DIR)/$(BIN_NAME).debug: $(WORK_DIR)/$(BIN_NAME)
	@mkdir -p $(dir $@)
	$(CP_FILE) $< $@

$(TARGET_DIR)/$(BIN_NAME): $(TARGET_DIR)/$(BIN_NAME).debug
	@$(CP_FILE) $< $@.tmp
	$(info $(STRIP) $@)
	@$(STRIP) $@.tmp
	@mv $@.tmp $@
