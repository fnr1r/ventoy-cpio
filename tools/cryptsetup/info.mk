NAME := cryptsetup
VERSION := 1.7.5

BIN_NAME := veritysetup

SRC_EXTRACTED := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.xz
SRC_URL := https://mirrors.edge.kernel.org/pub/linux/utils/cryptsetup/v1.7/$(SRC_FILENAME)
SRC_DIR := src
