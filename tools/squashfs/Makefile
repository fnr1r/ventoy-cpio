include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_build.mk

NAME := squashfs
VERSION := 4.4

SRC_DIR := $(NAME)$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.gz
SRC_URL := https://netix.dl.sourceforge.net/project/squashfs/squashfs/squashfs4.4/$(SRC_FILENAME)

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r dist src

$(call download_and_extract_tar,$(SRC_URL),$(SRC_FILENAME),$(SRC_DIR),src)

LZ4_NAME := lz4
LZ4_VERSION := 1.10.0
LZ4_DIR := $(LZ4_NAME)-$(LZ4_VERSION)
LZ4_FILENAME := $(LZ4_DIR).tar.gz
LZ4_URL := https://github.com/lz4/$(LZ4_NAME)/releases/download/v$(LZ4_VERSION)/$(LZ4_FILENAME)

$(call download_and_extract_tar,$(LZ4_URL),$(LZ4_FILENAME),$(LZ4_DIR),src/$(LZ4_NAME))

LZO_NAME := lzo
LZO_VERSION = 2.10
LZO_DIR := $(LZO_NAME)-$(LZO_VERSION)
LZO_FILENAME := $(LZO_DIR).tar.gz
LZO_URL := https://www.oberhumer.com/opensource/$(LZO_NAME)/download/$(LZO_FILENAME)

$(call download_and_extract_tar,$(LZO_URL),$(LZO_FILENAME),$(LZO_DIR),src/$(LZO_NAME))

XZ_NAME := xz
XZ_VERSION = 5.6.4
XZ_DIR := $(XZ_NAME)-$(XZ_VERSION)
XZ_FILENAME := $(XZ_DIR).tar.xz
XZ_URL := https://github.com/tukaani-project/$(XZ_NAME)/releases/download/v$(XZ_VERSION)/$(XZ_FILENAME)

$(call download_and_extract_tar,$(XZ_URL),$(XZ_FILENAME),$(XZ_DIR),src/$(XZ_NAME))

ZLIB_NAME := zlib
ZLIB_VERSION := 1.3.1
ZLIB_DIR := $(ZLIB_NAME)-$(ZLIB_VERSION)
ZLIB_FILENAME := $(ZLIB_DIR).tar.xz
ZLIB_URL := https://github.com/madler/$(ZLIB_NAME)/releases/download/v$(ZLIB_VERSION)/$(ZLIB_FILENAME)

$(call download_and_extract_tar,$(ZLIB_URL),$(ZLIB_FILENAME),$(ZLIB_DIR),src/$(ZLIB_NAME))

ZSTD_NAME := zstd
ZSTD_VERSION := 1.5.7
ZSTD_DIR := $(ZSTD_NAME)-$(ZSTD_VERSION)
ZSTD_FILENAME := $(ZSTD_DIR).tar.zst
ZSTD_URL := https://github.com/facebook/$(ZSTD_NAME)/releases/download/v$(ZSTD_VERSION)/$(ZSTD_FILENAME)

$(call download_and_extract_tar,$(ZSTD_URL),$(ZSTD_FILENAME),$(ZSTD_DIR),src/$(ZSTD_NAME))

dist/%/$(BIN_NAME): build.sh | src src/lz4 src/lzo src/xz src/zlib src/zstd
	@mkdir -p $(dir $@)
	+bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))
