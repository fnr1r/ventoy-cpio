NAME := lz4
VERSION := 1.10.0

BIN_NAME := $(NAME)cat

SRC_EXTRACTED := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.gz
SRC_URL := https://github.com/lz4/$(NAME)/releases/download/v$(VERSION)/$(SRC_FILENAME)
SRC_DIR := src
