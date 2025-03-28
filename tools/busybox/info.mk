NAME := busybox
VERSION := 1.32.0

BIN_NAMES := ash busybox hexdump xzcat

SRC_EXTRACTED := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.bz2
SRC_URL := https://busybox.net/downloads/$(SRC_FILENAME)
SRC_DIR := src
