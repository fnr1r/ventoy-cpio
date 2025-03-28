NAME := lunzip
VERSION := 1.11

BIN_NAME := $(NAME)cat

SRC_EXTRACTED := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.gz
SRC_URL := https://download.savannah.gnu.org/releases/lzip/$(NAME)/$(SRC_FILENAME)
SRC_DIR := src
