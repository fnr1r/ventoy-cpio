ifndef TARGET
$(error TARGET is not defined)
endif

.PHONY: all build clean
all: build
build:
clean:

BUILD_DIR := $(HERE)/build
DIST_DIR := $(HERE)/dist
SRC_DIR := $(HERE)/src
