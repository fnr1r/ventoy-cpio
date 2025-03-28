ifndef TARGET
$(error TARGET is not defined)
endif

.PHONY: all build clean
all: build
build:
clean:

BUILD_DIR := build
DIST_DIR := dist
TARGET_DIR := $(DIST_DIR)/$(TARGET)
WORK_DIR := $(BUILD_DIR)/$(TARGET)
