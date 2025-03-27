NAME := zstd
VERSION := 1.0.0

BIN_NAME := $(NAME)cat

SRC_EXTRACTED := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.gz
SRC_URL := https://codeload.github.com/facebook/$(NAME)/tar.gz/refs/tags/v$(VERSION)
SRC_DIR := src
