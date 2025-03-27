NAME := squashfs
VERSION := 4.4

SRC_EXTRACTED := $(NAME)$(VERSION)
SRC_FILENAME := $(SRC_EXTRACTED).tar.gz
SRC_URL := https://netix.dl.sourceforge.net/project/squashfs/squashfs/squashfs4.4/$(SRC_FILENAME)
SRC_DIR := src

BIN_NAME := un$(NAME)

LZ4_NAME := lz4
LZ4_VERSION := 1.10.0
LZ4_EXTRACTED := $(LZ4_NAME)-$(LZ4_VERSION)
LZ4_FILENAME := $(LZ4_EXTRACTED).tar.gz
LZ4_URL := https://github.com/lz4/$(LZ4_NAME)/releases/download/v$(LZ4_VERSION)/$(LZ4_FILENAME)
LZ4_DIR := $(SRC_DIR)/$(LZ4_NAME)
LZ4_TARGET := liblz4.a

LZO_NAME := lzo
LZO_VERSION = 2.10
LZO_EXTRACTED := $(LZO_NAME)-$(LZO_VERSION)
LZO_FILENAME := $(LZO_EXTRACTED).tar.gz
LZO_URL := https://www.oberhumer.com/opensource/$(LZO_NAME)/download/$(LZO_FILENAME)
LZO_DIR := $(SRC_DIR)/$(LZO_NAME)
LZO_TARGET := liblzo2.a

XZ_NAME := xz
XZ_VERSION = 5.6.4
XZ_EXTRACTED := $(XZ_NAME)-$(XZ_VERSION)
XZ_FILENAME := $(XZ_EXTRACTED).tar.xz
XZ_URL := https://github.com/tukaani-project/$(XZ_NAME)/releases/download/v$(XZ_VERSION)/$(XZ_FILENAME)
XZ_DIR := $(SRC_DIR)/$(XZ_NAME)
XZ_TARGET := liblzma.a

ZLIB_NAME := zlib
ZLIB_VERSION := 1.3.1
ZLIB_EXTRACTED := $(ZLIB_NAME)-$(ZLIB_VERSION)
ZLIB_FILENAME := $(ZLIB_EXTRACTED).tar.xz
ZLIB_URL := https://github.com/madler/$(ZLIB_NAME)/releases/download/v$(ZLIB_VERSION)/$(ZLIB_FILENAME)
ZLIB_DIR := $(SRC_DIR)/$(ZLIB_NAME)
ZLIB_TARGET := libz.a

ZSTD_NAME := zstd
ZSTD_VERSION := 1.5.7
ZSTD_EXTRACTED := $(ZSTD_NAME)-$(ZSTD_VERSION)
ZSTD_FILENAME := $(ZSTD_EXTRACTED).tar.zst
ZSTD_URL := https://github.com/facebook/$(ZSTD_NAME)/releases/download/v$(ZSTD_VERSION)/$(ZSTD_FILENAME)
ZSTD_DIR := $(SRC_DIR)/$(ZSTD_NAME)
ZSTD_TARGET := libzstd.a

GZIP_SUPPORT=1
XZ_SUPPORT=1
LZO_SUPPORT=1
LZ4_SUPPORT=1
ZSTD_SUPPORT=1
LZMA_XZ_SUPPORT=1
