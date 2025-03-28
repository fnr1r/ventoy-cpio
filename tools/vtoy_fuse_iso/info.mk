NAME := vtoy_fuse_iso

BIN_NAME := $(NAME)

SRC_DIR := src

FUSE_NAME := fuse
FUSE_VERSION := 2.9.9

FUSE_EXTRACTED := $(FUSE_NAME)-$(FUSE_VERSION)
FUSE_FILENAME := $(FUSE_EXTRACTED).tar.gz
FUSE_URL := https://github.com/libfuse/lib$(FUSE_NAME)/releases/download/$(FUSE_EXTRACTED)/$(FUSE_FILENAME)
FUSE_DIR := src/libfuse
#FUSE_TARGET := libfuse.a
