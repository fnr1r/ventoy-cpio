ifndef TARGET
$(error TARGET is not defined)
endif

.PHONY: all build clean clean-all
all: build
build:
clean:
clean-all:

BUILD_DIR := build
DIST_DIR := dist
SRC_DIR := src
