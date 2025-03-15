include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_WITHOUT_MIPS)

include $(SCRIPTS_DIR)/shared_build.mk

NAME := busybox
VERSION := 1.32.0

BIN_NAMES := ash busybox hexdump xzcat

SRC_DIR := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.bz2
SRC_URL := https://busybox.net/downloads/$(SRC_FILENAME)

CONFIGS := $(patsubst configs/%.config,dist/%,$(wildcard configs/*.config))

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r dist src

$(call download_and_extract_tar,$(SRC_URL),$(SRC_FILENAME),$(SRC_DIR),src)

dist:
	mkdir -p $@

dist/%: | src dist
	bash build.sh $(patsubst dist/%,%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): $(foreach bin,$(BIN_NAMES), dist/$(arch)_$(bin) )	\
))
