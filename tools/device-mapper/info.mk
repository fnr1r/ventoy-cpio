NAME := device-mapper
VERSION := 1.02.28

BIN_NAME := dmsetup

SRC_EXTRACTED := $(NAME).$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tgz
SRC_URL := ftp://sourceware.org/pub/dm/$(SRC_FILENAME)
SRC_DIR := src
