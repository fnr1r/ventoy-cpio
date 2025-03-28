NAME := busybox
VERSION := 1.32.0

BIN_NAMES := ash busybox hexdump xzcat

SRC_EXTRACTED := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.bz2
SRC_URL := https://busybox.net/downloads/$(SRC_FILENAME)
SRC_DIR := src

CONFIG_ASH := 03-ash-extras.config
CONFIG_BUSYBOX := 01-defconfig-static.config
CONFIG_HEXDUMP := 03-hexdump.config
CONFIG_XZCAT := 03-xzcat-only.config

split_binname = $(subst /, ,$(subst -, ,$(patsubst dist/%,%,$1)))
get_arch = $(firstword $(call split_binname,$1))
get_bin = $(lastword $(call split_binname,$1))
